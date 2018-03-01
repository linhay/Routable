//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import Foundation

public extension Double {
  /// Double转Int
  public var int: Int { return Int(self) }
  /// Double转String
  public var string: String { return String(self) }
  /// Double转CGFloat
  public var cgFloat: CGFloat { return CGFloat(self) }
  /// Double转Float
  public var float: Float { return Float(self) }
  /// 绝对值
  public var abs: Double { return Swift.abs(self) }
}

// MARK: - format
public extension Double{
  /// 四舍五入
  ///
  /// - Parameter places: 保留位数
  /// - Returns: double
  public func round(places: Int = 0) -> Double {
    let divisor = pow(10.0, Double(places))
    return Darwin.round(self * divisor) / divisor
  }

  /// 向上取整
  ///
  /// - Parameter places: 保留位数
  /// - Returns: double
  public func ceil(places: Int = 0) -> Double {
    let divisor = pow(10.0, Double(places))
    return Darwin.ceil(self * divisor) / divisor
  }

  /// 向下取整
  ///
  /// - Parameter places: 保留位数
  /// - Returns: double
  public func floor(places: Int = 0) -> Double {
    let divisor = pow(10.0, Double(places))
    return Darwin.floor(self * divisor) / divisor
  }

  /// 中国区价格类型
  public var price: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "ii_CN")
    return formatter.string(from: self as NSNumber)!
  }

  /// 当地价格类型
  public var localePrice: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    return formatter.string(from: self as NSNumber)!
  }
}
