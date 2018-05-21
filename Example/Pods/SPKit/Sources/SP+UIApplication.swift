//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit
// MARK: - open
public extension UIApplication {
  
  /// 打开链接 (会判断 能否打开)
  ///
  /// - Parameter url: url
  public func open(url: String) {
    guard let str = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: str),
      UIApplication.shared.canOpenURL(url) else{ return }
    unsafeOpen(url: url)
  }
  
  /// 打开链接 (不会判断 能否打开)
  ///
  /// - Parameter url: url
  public func unsafeOpen(url: String) {
    guard let str = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: str) else { return }
    unsafeOpen(url: url)
  }
  
  /// 打开链接 (不会判断 能否打开)
  ///
  /// - Parameter url: url
  public func unsafeOpen(url: URL) {
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  
}

