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
  /// 路由类缓存
  static var classCache = [String: NSObject]()
  /// 代理缓存
  static var replceCache = [String: String]()
  /// 回调缓存
  static var blockCache = [String: (_: [String: Any])->()]()
  
  
  struct Function {
    /// 函数
    let sel: Selector
    /// 函数参数数量
    let argumentCount: UInt32
    /// 返回值类型
    let returnType: ObjectType
    /// 参数类型数组
    let argumentTypes: [ObjectType]
  }
  
  /// class信息
  struct ClassInfo {
    let name: String
    let funcs: [Function]
  }
  
  struct Result {
    /// 返回值
    let unmanaged: Unmanaged<AnyObject>
    /// 返回值类型
    let type: ObjectType
  }
  
}

public extension Routable {
  
  /// 解析viewController类型
  ///
  /// - Parameter url: viewController 路径
  /// - Returns: viewController 或者 nil
  public static func viewController(url: URLCoin,params:[String: Any] = [:]) -> UIViewController? {
    return object(url: url, params: params) as UIViewController?
  }
  
  /// 解析view类型
  ///
  /// - Parameter url: view 路径
  /// - Returns: view 或者 nil
  public static func view(url: URLCoin,params:[String: Any] = [:]) -> UIView? {
    return object(url: url, params: params) as UIView?
  }
  
  /// 执行路径指定函数
  ///
  /// - Parameter url: 函数路径
  public static func executing(url: URLCoin, params:[String: Any] = [:]) {
    _ = object(url: url, params: params) as Any?
  }
  
  /// 解析AnyObject类型
  ///
  /// - Parameters:
  ///   - url: url
  ///   - params: url 参数(选填)
  /// - Returns: AnyObject 数据
  public static func object<T: Any>(url: URLCoin,params:[String: Any] = [:]) -> T? {
    guard let path = urlFormat(url: url, params: params) else { return nil }
    guard let value = getPathValues(url: path) else { return nil }
    guard let result = target(name: value.class, actionName: value.function, params: value.params) else { return nil }
    switch result.type {
    case .void: return nil
    case .object:
      return result.unmanaged.takeUnretainedValue() as? T
    case .longlong,.point,.int:
      return result.unmanaged.toOpaque().hashValue as? T
    case .double: return nil
    default: return nil
    }
  }
  
  /// 解析AnyObject类型(回调形式)
  ///
  /// - Parameters:
  ///   - url: url
  ///   - params: url 参数(选填)
  ///   - call: 回调数据
  @discardableResult public static func object(url: URLCoin, params:[String: Any] = [:], call: @escaping (_: [String: Any])->()) -> Any? {
    guard let path = urlFormat(url: url, params: params) else { return nil }
    guard let value = getPathValues(url: path) else { return nil }
    let id = "blockCache\(blockCache.count)"
    blockCache[id] = call
    return target(name: value.class, actionName: value.function, params: value.params, callId: id)
  }
  
  /// 执行回调
  ///
  /// - Parameters:
  ///   - id: 回调id(自动生成并传递)
  ///   - params: 回调数据
  ///   - isRemove: 是否移除本次回调(默认移除)
  public static func callback(id:String, params:[String: Any] = [:],isRemove: Bool = true) {
    blockCache[id]?(params)
    if isRemove { blockCache[id] = nil }
  }
  
  /// 通知所有已缓存类型函数
  ///
  /// - Parameter url: 函数路径
  public static func notice(url: URLCoin,params:[String: Any] = [:]) {
    guard let path = urlFormat(url: url, params: params) else { return }
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

public extension Routable {
  
  /// 清除指定缓存
  ///
  /// - Parameter name: key
  public static func cache(remove name: String) {
    let targetName = classPrefix + name
    classCache.removeValue(forKey: targetName)
  }
  
  /// 格式化url
  ///
  /// - Parameters:
  ///   - url: 待格式化 url 或 url 字符串
  ///   - params: 待拼接入url得参数
  /// - Returns: 合并后的 url
  public static func urlFormat(url: URLCoin,params:[String: Any]) -> URL?{
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
  static func getClass(name: String) -> NSObject? {
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
  static func getSEL(target: NSObject, name: String) -> Function? {
    var methodNum: UInt32 = 0
    let methods = class_copyMethodList(type(of: target), &methodNum)
    let list = (0..<numericCast(methodNum)).flatMap { (index) -> Function? in
      guard let method = methods?[index] else { return nil }
      let sel: Selector = method_getName(method)
      guard sel.description.hasPrefix(funcPrefix + name) else { return nil }
      var dst: CChar = 0
      method_getReturnType(method, &dst, MemoryLayout<CChar>.size)
      let returnType = ObjectType(char: dst)
      
      let argumentsCount = method_getNumberOfArguments(method)
      let types = (0..<UInt32(argumentsCount)).map({ (index) -> ObjectType in
        method_getArgumentType(method,index,&dst,MemoryLayout<CChar>.size)
        return ObjectType(char: dst)
      })
      return Function(sel: sel,
                      argumentCount: argumentsCount,
                      returnType: returnType,
                      argumentTypes: types)
      }.sorted { (func1, func2) -> Bool in
        let funcName1 = func1.sel.description
          .components(separatedBy: ":").first?
          .components(separatedBy: "With" + paramName).first ?? ""
        let funcName2 = func2.sel.description
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
  static func target(name: String, actionName: String, params: [String: Any] = [:], callId: String = "") -> Result? {
    guard let target = getClass(name: name) else { return nil }
    guard let function = getSEL(target: target, name: actionName) else { return nil }
    switch function.argumentCount {
    case 2:
      guard let value = target.perform(function.sel) else { return nil }
      return Result(unmanaged: value, type: function.returnType)
    case 3:
      guard let value = target.perform(function.sel, with: params) else { return nil }
      return Result(unmanaged: value, type: function.returnType)
    case 4:
      guard let value = target.perform(function.sel, with: params, with: callId) else { return nil }
      return Result(unmanaged: value, type: function.returnType)
    default:
      assert(false)
      return nil
    }
  }
  
  /// 处理参数类型
  ///
  /// - Parameter string: 需要处理的参数字符
  /// - Returns: 处理后类型
  static func dealValueType(string: String?) -> Any? {
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
  static func getPathValues(url: URL) -> (class: String,function: String,params: [String: Any])?{
    
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





