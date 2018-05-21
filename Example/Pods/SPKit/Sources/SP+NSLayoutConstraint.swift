//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit
public extension NSLayoutConstraint {
  
  /// 改变Constant 增加或者减少
  /// - Parameter offSet: 变化量
  public func change(offest: CGFloat) {
    let nowConstant = self.constant
    self.constant = nowConstant + offest
  }
  
  /// 修改倍率
  ///
  /// - Parameter multiplier: 新倍率
  /// - Returns: Constraint
  public func change(multiplier: CGFloat) -> NSLayoutConstraint {
    NSLayoutConstraint.deactivate([self])
    
    let newConstraint = NSLayoutConstraint(
      item: self.firstItem as Any,
      attribute: self.firstAttribute,
      relatedBy: self.relation,
      toItem: self.secondItem,
      attribute: self.secondAttribute,
      multiplier: multiplier,
      constant: self.constant)
    
    newConstraint.priority = self.priority
    newConstraint.shouldBeArchived = self.shouldBeArchived
    newConstraint.identifier = self.identifier
    
    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
  }
  
}

