//
//  Router.swift
//  Router
//
//  Created by BigL on 2017/3/21.
//  Copyright © 2017年 fun.bigl.com. All rights reserved.
//

import Foundation
import UIKit

public struct Routable {
  /// 命名空间
  fileprivate static let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
  /// 类名前缀
  public static var classPrefix = "Router_"
  /// 方法名前缀
  public static var funcPrefix = "router_"
  /// 参数名
  public static var paramName = "Params"
  /// 指定协议头, ""则为任意格式
  public static var scheme = ""
  /// 缓存
  static var cache = [String: Any]()
  /// 通知缓存
  static var notice = [String:[String]]()
  /// 代理缓存
  static var delegate = [String: String]()

  enum Style {
    case object
    case execute
  }

}

public extension Routable {

  /// 清除指定缓存
  ///
  /// - Parameter name: key
  public static func cache(remove name: String) {
    let targetName = classPrefix + name
    cache.removeValue(forKey: targetName)
  }

  public static func urlFormat(url: URLProtocol,params:[String: Any]) -> URL?{
    if params.isEmpty { return url.asURL() }
    guard var components = URLComponents(string: url.asString()) else { return nil }
    var querys = components.queryItems ?? []
    let newQuerys = params.map { (item) -> URLQueryItem in
      switch item.value {
      case let v as String:
        return URLQueryItem(name: item.key, value: v)
      case let v as [String:Any]:
        return URLQueryItem(name: item.key, value: RoutableHelp.formatJSON(data: v))
      case let v as [Any]:
        return URLQueryItem(name: item.key, value: RoutableHelp.formatJSON(data: v))
      default:
        return URLQueryItem(name: item.key, value: String(describing: item.value))
      }
    }
    querys += newQuerys
    components.queryItems = querys
    return components.url
  }

  /// 解析viewController类型
  ///
  /// - Parameter url: viewController 路径
  /// - Returns: viewController 或者 nil
  public static func viewController(url: URLProtocol,params:[String: Any] = [:]) -> UIViewController? {
    if let vc = object(url: url, params: params) as UIViewController? { return vc }
    assert(false, "无法解析为UIViewController类型:" + url.asString())
    return nil
  }

  /// 解析view类型
  ///
  /// - Parameter url: view 路径
  /// - Returns: view 或者 nil
  public static func view(url: URLProtocol,params:[String: Any] = [:]) -> UIView? {
    if let vc = object(url: url, params: params) as UIView? { return vc }
    assert(false, "无法解析为UIView类型:" + url.asString())
    return nil
  }

  /// 解析AnyObject类型
  ///
  /// - Parameter url: view 路径
  /// - Returns: view 或者 nil
  public static func object<T: Any>(url: URLProtocol,params:[String: Any] = [:]) -> T? {
    guard let path = urlFormat(url: url, params: params) else { return nil }
    guard let object = Routable.perform(value: path) else { return nil }
    switch String(describing: T.self) {
    case "Int":
      return object.toOpaque().hashValue as? T
    case "UInt":
      let hash = object.toOpaque().hashValue
      if hash > UInt.max || hash < UInt.min { return nil }
      return UInt(hash) as? T
    case "UInt8":
      let hash = object.toOpaque().hashValue
      if hash > UInt8.max || hash < UInt8.min { return nil }
      return UInt8(hash) as? T
    case "UInt16":
      let hash = object.toOpaque().hashValue
      if hash > UInt16.max || hash < UInt16.min { return nil }
      return UInt16(hash) as? T
    case "UInt32":
      let hash = object.toOpaque().hashValue
      if hash > UInt32.max || hash < UInt32.min { return nil }
      return UInt32(hash) as? T
    case "UInt64":
      let hash = object.toOpaque().hashValue
      if hash > UInt64.max || hash < UInt64.min { return nil }
      return UInt64(hash) as? T
    default:
      if let element = object.takeUnretainedValue() as? T { return element }
    }
    return nil
  }


  /// 通知所有已缓存类型函数
  ///
  /// - Parameter url: 函数路径
  public static func notice(url: URLProtocol,params:[String: Any] = [:]) {
    guard let path = urlFormat(url: url, params: params) else { return }
    if path.host != "notice" {
      assert(false, "检查 URL host: " + (path.host ?? "") + "🌰: http://notice/path")
      return
    }

    cache.keys.forEach({ (item) in
      //TODO: 不太严谨
      let name = item.replacingOccurrences(of: classPrefix, with: "")
      let path = path.asString().replacingOccurrences(of: "://notice/", with: "://\(name)/")
      if let endURL = path.asURL() {
        Routable.perform(function: endURL)
      }
    })
  }


  /// 执行路径指定函数
  ///
  /// - Parameter url: 函数路径
  public static func executing(url: URLProtocol, params:[String: Any] = [:]) {
    guard let path = urlFormat(url: url, params: params) else { return }
    Routable.perform(function: path)
  }

}

extension Routable {

  /// 获取类对象
  ///
  /// - Parameter name: 类名
  /// - Returns: 类对象
  static func getClass(name: String) -> NSObject? {
    func target(name: String) -> NSObject? {
      if let targetClass = cache[name] as? NSObject { return targetClass }
      guard let targetClass = NSClassFromString(name) as? NSObject.Type else { return nil }
      let target = targetClass.init()
      cache[name] = target
      return target
    }

    if let value = target(name: classPrefix + name) { return value }
    if let value = target(name: namespace + "." + classPrefix + name) { return value }
    return nil
  }

  /// 获取指定类指定函数
  ///
  /// - Parameters:
  ///   - target: 指定类
  ///   - name: 指定函数名
  ///   - hasParams: 是否有参数
  /// - Returns: 指定函数
  static func getSEL(target: NSObject, name: String,hasParams: Bool) -> Selector? {
    if hasParams {
      do {
        let sel = NSSelectorFromString(funcPrefix + name + "With" + paramName + ":")
        if target.responds(to: sel){ return sel }
      }

      do {
        let sel = NSSelectorFromString(funcPrefix + name + paramName + ":")
        if target.responds(to: sel){ return sel }
      }
      /// 匿名参数
      do {
        let sel = NSSelectorFromString(funcPrefix + name + ":")
        if target.responds(to: sel){ return sel }
      }

      return nil
    }else{
      let sel = NSSelectorFromString(funcPrefix + name)
      if target.responds(to: sel){ return sel }
      return getSEL(target: target, name: name, hasParams: true)
    }
  }

  /// 获取指定对象
  ///
  /// - Parameters:
  ///   - name: 类名
  ///   - actionName: 函数名
  ///   - params: 函数参数
  ///   - isCacheTarget: 是否缓存
  /// - Returns: 对象
  public static func execute(name: String,
                             actionName: String,
                             params: [String: Any] = [:]) {
    guard let target = getClass(name: name) else { return }
    guard let function = getSEL(target: target, name: actionName, hasParams: !params.isEmpty) else { return }

    switch function.description.hasSuffix(":") {
    case true:
      target.perform(function, with: params)
    case false:
      target.perform(function)
    }
  }

  /// 获取指定对象
  ///
  /// - Parameters:
  ///   - name: 类名
  ///   - actionName: 函数名
  ///   - params: 函数参数
  ///   - isCacheTarget: 是否缓存
  /// - Returns: 对象
  public static func target(name: String,
                            actionName: String,
                            params: [String: Any] = [:]) -> Unmanaged<AnyObject>? {
    guard let target = getClass(name: name) else { return nil }
    guard let function = getSEL(target: target, name: actionName, hasParams: !params.isEmpty) else { return nil }

    switch function.description.hasSuffix(":") {
    case true:
      guard let value = target.perform(function, with: params) else { return nil }
      return value
    case false:
      guard let value = target.perform(function) else { return nil }
      return value
    }
  }

  /// 获取路径所需参数
  ///
  /// - Parameter url: 路径
  /// - Returns: 所需参数
  static func getPathValues(url: URL) -> (class: String,function: String,params: [String: Any])?{
    /// 处理参数类型
    ///
    /// - Parameter string: 需要处理的参数字符
    /// - Returns: 处理后类型
    func dealValueType(string: String?) -> Any? {
      guard var str = string?.removingPercentEncoding else { return string }
      guard !str.isEmpty else { return str }
      str = str.trimmingCharacters(in: CharacterSet.whitespaces)
      guard str.hasPrefix("[") || str.hasPrefix("{") else { return str }
      let dict = RoutableHelp.dictionary(string: str)
      if !dict.isEmpty { return dict }
      let array = RoutableHelp.array(string: str)
      if !array.isEmpty { return array }
      return str
    }

    /// 处理协议头合法
    guard (scheme.isEmpty || url.scheme == scheme),
      let function = url.path.components(separatedBy: "/").last,
      let className = url.host else {
        assertionFailure("url 不合法")
        return nil
    }

    /// 处理参数
    var params = [String: Any]()
    if let urlstr = url.query {
      urlstr.components(separatedBy: "&").forEach { (item) in
        let list = item.components(separatedBy: "=")
        if list.count == 2 {
          params[list.first!] = dealValueType(string: list.last)
        }else if list.count > 2 {
          params[list.first!] = dealValueType(string: list.dropFirst().joined())
        }
      }
    }

    return (className,function,params)
  }


  /// 由路径获取指定函数并执行
  ///
  /// - Parameter url: 路劲
  static func perform(function url: URL) {
    guard let value = getPathValues(url: url) else { return }
    execute(name: value.class, actionName: value.function, params: value.params)
  }

  /// 由路径获取指定对象
  ///
  /// - Parameter url: 路径
  /// - Returns: 对象
  static func perform(value url: URL) -> Unmanaged<AnyObject>? {
    guard let value = getPathValues(url: url) else { return nil }
    let result = target(name: value.class, actionName: value.function, params: value.params)
    return result
  }

}





