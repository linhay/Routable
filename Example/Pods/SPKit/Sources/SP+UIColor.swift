//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension UIColor{
  
  /// 设置颜色透明度
  var alpha: CGFloat{
    set{ self.withAlphaComponent(newValue) }
    get{ return self.cgColor.alpha }
  }
  
  /// 随机色
  class var random: UIColor {
    get{
      return UIColor(red: CGFloat(Double(arc4random_uniform(255))/255.0),
                     green: CGFloat(Double(arc4random_uniform(255))/255.0),
                     blue: CGFloat(Double(arc4random_uniform(255))/255.0), alpha: 1)
    }
  }
  
  /// 十六进制色: 0x666666
  ///
  /// - Parameter RGBValue: 十六进制颜色
  convenience init(value: UInt) {
    self.init(
      red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(value & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  /// 十六进制色: 0x666666
  ///
  /// - Parameters:
  ///   - ARGBValue: 十六进制颜色
  ///   - Alpha: 透明度
  convenience init(value: UInt,alpha: CGFloat) {
    self.init(
      red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(value & 0x0000FF) / 255.0,
      alpha: alpha
    )
  }
}
