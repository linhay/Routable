//
//  SP+UIStoryboard.swift
//  BLFoundation
//
//  Created by linhey on 2018/5/9.
//

import UIKit

public extension UIStoryboard {
  /// 获取storyBoard中对应的UIViewController
  /// - Parameter type: ViewController类型
  /// - Returns: UIViewController
  public class func viewController<T: UIViewController>(with: T.Type) -> T? {
    let vcName = String(describing: T.self)
    return UIStoryboard(name: vcName, bundle: nil).instantiateInitialViewController() as? T
  }
}
