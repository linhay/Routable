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


  /// 修改倍率
  ///
  /// - Parameter multiplier: 新倍率
  /// - Returns: Constraint
  func change(multiplier: CGFloat) -> NSLayoutConstraint {
    NSLayoutConstraint.deactivate([self])

    let newConstraint = NSLayoutConstraint(
      item: firstItem as Any,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant)

    newConstraint.priority = priority
    newConstraint.shouldBeArchived = self.shouldBeArchived
    newConstraint.identifier = self.identifier

    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
  }

}
