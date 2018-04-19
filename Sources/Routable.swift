//
//  Router.swift
//  Router
//
//  Created by BigL on 2017/3/21.
//  Copyright © 2017年 fun.bigl.com. All rights reserved.
//

import UIKit
import Foundation
import RoutableAssist

class RoutableData {
  var id = ""
  var url: URL?
  var className = ""
  var selName = ""
  var params = [String: Any]()
  var blockId: Int = -1
  var invocation: Invocation?
  var isBadURL = false
}


public class Routable: NSObject {
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
  
  static var cache = [String: RoutableData]()
  /// 路由类缓存
  static var classCache = [String: NSObject]()
  /// 函数映射表
  static var invocationCache = [String: NSObject]()
  /// 回调缓存
  static var blockCache = [Int: (_: [String: Any])->()]()
}


// for Object-C
public extension Routable {
  
  /// 执行路径指定函数
  ///
  /// - Parameter url: url
  @objc public class func executing(urlStr: String) {
    _ = object(url: urlStr)
  }
  
  /// 执行路径指定函数
  ///
  /// - Parameter url: url
  ///   - arguments: url 参数
  @objc public class func executing(urlStr: String, arguments:[String: Any]) {
    _ = object(url: urlStr, params: arguments)
  }
  
  /// 通知所有已缓存类型函数
  ///
  /// - Parameter url: url
  @objc public class func notice(urlStr: String) {
    notice(url: urlStr)
  }
  
  /// 通知所有已缓存类型函数
  ///
  /// - Parameters:
  ///   - urlStr: urlStr
  ///   - arguments: url 参数
  @objc public class func notice(urlStr: String,arguments:[String: Any]) {
    notice(url: urlStr, params: arguments)
  }
  
  /// 解析viewController类型
  ///
  /// - Parameter url: url
  /// - Returns: viewController or nil
  @objc public class func viewController(urlStr: String) -> UIViewController? {
    return viewController(url: urlStr)
  }
  
  /// 解析viewController类型
  ///
  /// - Parameters:
  ///   - urlStr: url
  ///   - arguments: url 参数
  /// - Returns: viewController or nil
  @objc public class func viewController(urlStr: String, arguments:[String: Any]) -> UIViewController? {
    return viewController(url:urlStr ,params: arguments)
  }
  
  /// 解析view类型
  ///
  /// - Parameter url: url
  /// - Returns: view or nil
  @objc public class func view(urlStr: String) -> UIView? {
    return view(url: urlStr)
  }
  
  /// 解析view类型
  ///
  /// - Parameters:
  ///   - urlStr: url
  ///   - arguments: url 参数
  /// - Returns: view or nil
  @objc public class func view(urlStr: String, arguments:[String: Any]) -> UIView? {
    return view(url: urlStr, params: arguments)
  }
  
  /// 解析Any类型(回调形式)
  ///
  /// - Parameters:
  ///   - urlStr: url
  @discardableResult @objc public class func object(urlStr: String) -> Any? {
    return object(url: urlStr, params: [:], call: nil)
  }
  
  /// 解析Any类型(回调形式)
  ///
  /// - Parameters:
  ///   - urlStr: url
  ///   - arguments: url 参数
  @discardableResult @objc public class func object(urlStr: String,
                                                    arguments:[String: Any]) -> Any? {
    return object(url: urlStr, params: arguments, call: nil)
  }
  
  /// 解析Any类型(回调形式)
  ///
  /// - Parameters:
  ///   - urlStr: url
  ///   - arguments: url 参数(选填)
  ///   - call: 回调数据
  @discardableResult @objc public class func object(urlStr: String,
                                                    arguments:[String: Any] = [:],
                                                    call: ((_: [String: Any])->())? = nil) -> Any? {
    return object(url: urlStr, params: arguments, call: call)
  }
  
}



// MARK: - UIKit
public extension Routable {
  
  /// 解析viewController类型
  ///
  /// - Parameter url: viewController 路径
  /// - Returns: viewController 或者 nil
  public class func viewController(url: URLCoin,params:[String: Any] = [:]) -> UIViewController? {
    return object(url: url, params: params) as? UIViewController
  }
  
  /// 解析view类型
  ///
  /// - Parameter url: view 路径
  /// - Returns: view 或者 nil
  public class func view(url: URLCoin,params:[String: Any] = [:]) -> UIView? {
    return object(url: url, params: params) as? UIView
  }
  
}

// MARK: - block
extension Routable {
  
  
  /// 执行回调
  ///
  /// - Parameters:
  ///   - id: 回调id(自动生成并传递)
  public class func callback(id:Int) {
    callback(id: id, params: [:], isRemove: true)
  }
  
  /// 执行回调
  ///
  /// - Parameters:
  ///   - id: 回调id(自动生成并传递)
  ///   - params: 回调数据
  public class func callback(id:Int, params:[String: Any]) {
    callback(id: id, params: params, isRemove: true)
  }
  
  /// 执行回调
  ///
  /// - Parameters:
  ///   - id: 回调id(自动生成并传递)
  ///   - params: 回调数据
  ///   - isRemove: 是否移除本次回调(默认移除)
  public class func callback(id:Int, params:[String: Any],isRemove: Bool) {
    blockCache[id]?(params)
    if isRemove { blockCache[id] = nil }
  }
  
  
}

extension Routable {
  
  /// 执行路径指定函数
  ///
  /// - Parameter url: 函数路径
  public class func executing(url: URLCoin, params:[String: Any] = [:]) {
    _ = object(url: url, params: params)
  }
  
  /// 通知所有已缓存类型函数
  ///
  /// - Parameter url: 函数路径
  public class func notice(url: URLCoin,params:[String: Any] = [:]) {
    guard let path = createURL(url: url, params: params) else { return }
    if path.host != "notice" {
      assert(false, "检查 URL host: " + (path.host ?? "") + "🌰: http://notice/path")
      return
    }
    
    classCache.keys.forEach({ (item) in
      //TODO: 不太严谨
      let name = item.replacingOccurrences(of: classPrefix, with: "")
      let path = path.asString().replacingOccurrences(of: "://notice/", with: "://\(name)/")
      if let endURL = path.asURL() {
        _ = object(url: endURL) as Any?
      }
    })
  }
  
}

extension Routable {
  
  /// 解析Any类型(回调形式)
  ///
  /// - Parameters:
  ///   - url: url
  ///   - params: url 参数(选填)
  ///   - call: 回调数据
  @discardableResult public class func object(url: URLCoin,
                                              params:[String: Any] = [:],
                                              call: ((_: [String: Any])->())? = nil) -> Any? {
    guard let url = createURL(url: url, params: params) else { return nil }
    guard let value = urlParse(url: url) else { return nil }
    let cacheId = (url.host ?? "") + url.path
    let blockId = cacheId.hashValue
    blockCache[blockId] = call
    
    
    if let data = cache[cacheId] {
      if data.isBadURL { return nil }
      if let inv = data.invocation {
        invSetParams(inv: inv, params: value.params, callId: blockId)
        inv.invoke()
        return invReturnValue(inv: inv)
      }
      assert(false, "不应该出现")
    }
    
    let data = RoutableData()
    data.url = url
    data.className = value.class
    data.selName = value.function
    data.params = value.params
    data.blockId = blockId
    
    return target(data: data)
  }
  
}

public extension Routable {
  
  /// 清除指定缓存
  ///
  /// - Parameter name: key
  public class func cache(remove name: String) {
    let targetName = classPrefix + name
    classCache.removeValue(forKey: targetName)
  }
  
  /// 格式化url
  ///
  /// - Parameters:
  ///   - url: 待格式化 url 或 url 字符串
  ///   - params: 待拼接入url得参数
  /// - Returns: 合并后的 url
  public class func createURL(url: URLCoin,params:[String: Any]) -> URL?{
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
  
}

extension Routable {
  
  /// 获取类对象
  ///
  /// - Parameter name: 类名
  /// - Returns: 类对象
  class func getClass(name: String) -> NSObject? {
    func target(name: String) -> NSObject? {
      if let targetClass = classCache[name] { return targetClass }
      guard let targetClass = NSClassFromString(name) as? NSObject.Type else { return nil }
      let target = targetClass.init()
      classCache[name] = target
      return target
    }
    
    if let value = target(name: classPrefix + name) { return value }
    // 不在主工程中的swift类
    if let value = target(name: namespace + "." + classPrefix + name) { return value }
    return nil
  }
  
  /// 获取指定类指定函数
  ///
  /// - Parameters:
  ///   - target: 指定类
  ///   - name: 指定函数名
  /// - Returns: 指定函数
  class func getSEL(target: NSObject, name: String) -> Selector? {
    var methodNum: UInt32 = 0
    let methods = class_copyMethodList(type(of: target), &methodNum)
    let list = (0..<numericCast(methodNum)).flatMap { (index) -> Selector? in
      guard let method = methods?[index] else { return nil }
      let sel: Selector = method_getName(method)
      guard sel.description.hasPrefix(funcPrefix + name) else { return nil }
      return sel
      }.sorted { (func1, func2) -> Bool in
        let funcName1 = func1.description
          .components(separatedBy: ":").first?
          .components(separatedBy: "With" + paramName).first ?? ""
        let funcName2 = func2.description
          .components(separatedBy: ":").first?
          .components(separatedBy: "With" + paramName).first ?? ""
        return funcName1.count < funcName2.count
    }
    free(methods)
    return list.first
  }
  
  /// 获取指定对象
  ///
  /// - Parameters:
  ///   - name: 类名
  ///   - actionName: 函数名
  ///   - params: 函数参数
  ///   - isCacheTarget: 是否缓存
  /// - Returns: 对象
  class func target(data: RoutableData) -> Any? {
    guard
      let target = getClass(name: data.className),
      let sel = getSEL(target: target, name: data.selName),
      let sig = Proxy.methodSignature(target, sel: sel),
      let inv = Invocation(methodSignature: sig)
      else {
        data.isBadURL = true
        cache[data.id] = data
        return nil
    }
    
    inv.target = target
    inv.selector = sel
    inv.invoke()
    var returnType = ObjectType(char: sig.methodReturnType)
    switch returnType {
    case .longlong,.point,.int:
      var value: Int = 0
      inv.getReturnValue(&value)
      return value
    case .double:
      var value: Double = 0.0
      inv.getReturnValue(&value)
      return value
    case .bool:
      var value: Bool?
      inv.getReturnValue(&value)
      return value
    case .object:
      var value: NSObject? = nil
      inv.getReturnValue(&value)
      print(value)
      print(CFGetRetainCount(value as CFTypeRef) - 1)
      print(String(format: "%p", value as! CVarArg))
      return value
    case .void:
      return nil
    case .sel:
      var value: Selector?
      inv.getReturnValue(&value)
      return value
    default:
      return nil
    }
    
    let res = invReturnValue(inv: inv)
    
    data.isBadURL = false
    cache[data.id] = data
    return res
  }
  
  
  // 参数设置
  class func invSetParams(inv: Invocation,params: [String: Any],callId: Int) {
    (0..<inv.methodSignature.numberOfArguments).map { (index) -> ObjectType in
      return ObjectType(char: inv.methodSignature.getArgumentType(at: index))
      }
      .dropFirst(2)
      .enumerated()
      .forEach { (element) in
        switch element.element {
        case .int:
          var item = callId
          inv.setArgument(&item, at: element.offset + 2)
        case .object:
          var item = params
          inv.setArgument(&item, at: element.offset + 2)
        default: break
        }
    }
  }
  // 处理返回值类型
  class func invReturnValue(inv: Invocation) -> Any? {
    
    let returnType = ObjectType(char: inv.methodSignature.methodReturnType)
    switch returnType {
    case .bool:
      var value: Bool?
      inv.getReturnValue(&value)
      return value
    case .double:
      var value: Double?
      inv.getReturnValue(&value)
      return value
    case .object:
      var value: NSObject?
      inv.getReturnValue(&value)
      return value
    case .void:
      return nil
    case .longlong,.point,.int:
      var value: Int?
      inv.getReturnValue(&value)
      return value
    case .sel:
      var value: Selector?
      inv.getReturnValue(&value)
      return value
    default:
      return nil
    }
  }
  
  /// 处理参数类型
  ///
  /// - Parameter string: 需要处理的参数字符
  /// - Returns: 处理后类型
  class func dealValueType(string: String?) -> Any? {
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
  
  
  
  /// 获取路径所需参数
  ///
  /// - Parameter url: 路径
  /// - Returns: 所需参数
  class func urlParse(url: URL) -> (class: String,function: String,params: [String: Any])?{
    
    /// 处理协议头合法
    guard (scheme.isEmpty || url.scheme == scheme),
      let function = url.path.components(separatedBy: "/").last,
      let className = url.host else { return nil }
    
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
  
}





