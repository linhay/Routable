//
//  Routable+Extension.swift
//  AModules
//
//  Created by linhey on 2018/5/13.
//

import UIKit

// MARK: - UIKit
public extension Routable {
  
  /// 解析viewController类型
  ///
  /// - Parameter url: viewController 路径
  /// - Returns: viewController 或者 nil
 @objc public class func viewController(url: String,params:[String: Any] = [:]) -> UIViewController? {
    return object(url: url, params: params) as? UIViewController
  }
  
  /// 解析view类型
  ///
  /// - Parameter url: view 路径
  /// - Returns: view 或者 nil
 @objc public class func view(url: String,params:[String: Any] = [:]) -> UIView? {
    return object(url: url, params: params) as? UIView
  }
  
}
