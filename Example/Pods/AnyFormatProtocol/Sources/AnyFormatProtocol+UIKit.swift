//
//  AnyFormatProtocol+UIKit.swift
//  AnyFormatProtocol
//
//  Created by linhey on 2018/6/29.
//

import UIKit

/// 处理模糊类型
///
/// - Parameter any: 待处理数据
/// - value: 默认值 default: 0
/// - Returns: Double
public extension AnyFormatProtocol{
  
  static func format(_ any: Any?, default value: CGFloat = 0) -> CGFloat {
    return AnyFormatModel.format(any, default: value)
  }
  
  func format(_ any: Any?, default value: CGFloat = 0) -> CGFloat {
    return AnyFormatModel.format(any, default: value)
  }
  
}

extension AnyFormatModel {
  static func format(_ any: Any?,default value: CGFloat = 0) -> CGFloat {
    guard let p = any else { return value }
    if let v = p as? NSNumber { return CGFloat(v.doubleValue) }
    if let v = p as? String {
      guard let c = v.double else { return value }
      return CGFloat(c)
    }
    return value
  }
}
