//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension NSLayoutConstraint {
  /// 改变Constant
 public func change(constant: CGFloat) {
    let nowConstant = self.constant
    self.constant = nowConstant + constant
  }

}
