//
//  Routable+oc.swift
//  AModules
//
//  Created by linhey on 2018/4/19.
//

import UIKit

// for Object-C
public extension Routable {
  
  /// 设置重定向规则组
  ///
  /// - Parameter rules: 重定向规则
  @objc public class func set(repleRules rules: [String: String]) {
    set(reple: rules)
  }

  
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
