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
  static var classPrefix = "Router_"
  /// 方法名前缀
  static var funcPrefix = "router_"
  /// 参数名
  static var paramName = "Params"
  /// 指定协议头, ""则为任意格式
  static var scheme = ""
  /// 缓存
  static var cache = [String: Any]()
  
}

public extension Routable {
  
  /// 清除指定缓存
  ///
  /// - Parameter name: key
  public static func cache(remove name: String) {
    let targetName = classPrefix + name
    cache.removeValue(forKey: targetName)
  }
  
  /// 解析viewController类型
  ///
  /// - Parameter url: viewController 路径
  /// - Returns: viewController 或者 nil
  public static func viewController(url: String) -> UIViewController? {
    guard let path = URL(string: url) else {
      assert(false, "url非法:" + url)
      return nil
    }
    let object = Routable.performAction(url: path)
    if let vc = object as? UIViewController { return vc }
    return nil
  }
  
  /// 解析view类型
  ///
  /// - Parameter url: view 路径
  /// - Returns: view 或者 nil
  public static func view(url: String) -> UIView? {
    guard let path = URL(string: url) else {
      assert(false, "url非法:" + url)
      return nil
    }
    
    let object = Routable.performAction(url: path)
    if let view = object as? UIView { return view }
    return nil
  }
  
  /// 解析AnyObject类型
  ///
  /// - Parameter url: view 路径
  /// - Returns: view 或者 nil
  public static func object<T: AnyObject>(url: String) -> T? {
    guard let path = URL(string: url) else {
      assert(false, "url非法:" + url)
      return nil
    }
    let object = Routable.performAction(url: path)
    if let element = object as? T { return element }
    return nil
  }
  
  /// 执行路径指定函数
  ///
  /// - Parameter url: 函数路径
  public static func executing(url: String) {
    guard let path = URL(string: url) else {
      assert(false, "url非法:" + url)
      return
    }
    _ = Routable.performAction(url: path)
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
  static func getFunc(target: NSObject, name: String,hasParams: Bool) -> Selector? {
    if hasParams {
      do {
        let sel = NSSelectorFromString(funcPrefix + name + "With" + paramName + ":")
        if target.responds(to: sel){ return sel }
      }
      do {
        let sel = NSSelectorFromString(funcPrefix + name + paramName + ":")
        if target.responds(to: sel){ return sel }
      }
      return nil
    }else{
      let sel = NSSelectorFromString(funcPrefix + name)
      if target.responds(to: sel){ return sel }
      return getFunc(target: target, name: name, hasParams: true)
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
                            params: [String: Any] = [:]) -> AnyObject? {
    
    guard let target = getClass(name: name) else {
      assert(false, "无法查询到指定类")
      return nil
    }
    
    guard let function = getFunc(target: target, name: actionName, hasParams: !params.isEmpty) else {
      assert(false, "无法查询到指定类函数")
      cache(remove: name)
      return nil
    }
    
    switch function.description.contains("Params:") {
    case true:
      guard let value = target.perform(function, with: params) else { return nil }
      return value.takeUnretainedValue()
    case false:
      guard let value = target.perform(function) else { return nil }
      return value.takeUnretainedValue()
    }
  }
  
  /// 由路径获取指定对象
  ///
  /// - Parameter url: 路径
  /// - Returns: 对象
  static func performAction(url: URL) -> AnyObject? {
    var params = [String: Any]()

    if !scheme.isEmpty, url.scheme! != scheme {
      assert(false, "url格式不正确:" + url.absoluteString)
      return nil
    }

    var urlstr = ""
    
    if let query = url.query { urlstr = query.removingPercentEncoding ?? "" }
    urlstr.components(separatedBy: "&").forEach { (item) in
      let list = item.components(separatedBy: "=")
      if list.count < 2 { return }
      params[list.first!] = list.last!
    }
    
    let actionName = url.path.replacingOccurrences(of: "/", with: "")
    let result = target(name: url.host!,
                        actionName: actionName,
                        params: params)
    return result
  }
  
}





