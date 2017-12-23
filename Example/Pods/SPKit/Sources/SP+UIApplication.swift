//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit
// MARK: - open
public extension UIApplication {

  /// 打开链接
  ///
  /// - Parameter url: url
  public class func open(url: URL) {
    if UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }

  /// 打开链接
  ///
  /// - Parameter string: url字符串
  public class func open(string: String) {
    guard let str = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{ return }
    guard let url = URL(string: str) else { return }
    open(url: url)
  }
}

// MARK: - swizzling
extension UIApplication {
  override open var next: UIResponder? {
    UIControl.swizzling()
    UILabel.swizzling()
    return super.next
  }
}
