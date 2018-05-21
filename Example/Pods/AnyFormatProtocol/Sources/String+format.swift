//
//  String+format.swift
//  Extensions
//
//  Created by BigL on 2017/7/8.
//

import Foundation
// MARK: - 转换
let NullString = ""
extension String {

  /// String: 转化为Int
  var int: Int? {
    guard let num = NumberFormatter().number(from: self) else { return nil }
    return num.intValue
  }

  /// String: 转化为 Double
  var double: Double? {
    guard let num = NumberFormatter().number(from: self) else{ return nil }
    return num.doubleValue
  }

  /// String: 转化为Float
  var float: Float? {
    guard let num = NumberFormatter().number(from: self) else{ return nil }
    return num.floatValue
  }

  /// String: 转化为 NSNumber
  var number: NSNumber? {
    guard let num = NumberFormatter().number(from: self) else{ return nil }
    return num
  }

  /// String: 转化为 Bool
  var bool: Bool? {
    if let num = NumberFormatter().number(from: self) {
      return num.boolValue
    }
    switch self.lowercased() {
    case "true","yes": return true
    case "false","no": return false
    default: return nil
    }
  }
}
