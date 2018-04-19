//
//  String+match.swift
//  Pods
//
//  Created by BigL on 2017/7/12.
//
//

import Foundation

// MARK: - Emoji
public extension String{

  /// 提取类型
  ///
  /// - emojis: emojis
  /// - regex: 正则
  enum ExtractMode {
    case emojis
    case illegal
    case regex(pattern: String)
  }

  /// 提取字符串中特定字符
  ///
  /// - Parameter state: 类型
  /// - Returns: 新串列表
  func extract(_ mode: ExtractMode) -> [String] {
    switch mode {
    case .emojis: return emojis
    case .illegal: return illegals
    case .regex(pattern: let pattern):
      return Regex(pattern).stringList(input: self)
    }
  }


  /// 提取非法字符
   var illegals: [String] {
    return self.flatMap { (item) -> String? in
      return String(item) =~ RegexPattern.illegal ? String(item) : nil
    }
  }

  /// 提取: Emojis
   var emojis: [String] {
    let elements = unicodeScalars.flatMap { (scalar) -> String? in
      switch scalar.value {
      case 0x3030,
           0x00AE,
           0x00A9,
           0x1D000...0x1F77F,
           0x2100...0x278A,
           0x2793...0x27BF,
           0xFE00...0xFE0F,
           0x1F900...0x1F9FF:
        return String(scalar)
      default: return nil
      }
    }
    return elements
  }
}


// MARK: - has
public extension String{

  enum HasMode {
    case emojis
    case illegal
  }

  /// 校验字符
  ///
  /// - Parameter state: 校验类型
  /// - Returns: 是否
  func has(_ mode: HasMode) -> Bool {
    switch mode {
    case .emojis: return !emojis.isEmpty
    case .illegal: return !illegals.isEmpty
    }
  }
}

// MARK: - is
public extension String{

  enum IsMode {
    case phone
    case number(digit: Int)
  }

  /// 判断字符串中特定字符
  ///
  /// - Parameter state: 类型
  /// - Returns: true/false
  func `is`(_ mode: IsMode) -> Bool {
    switch mode {
    case .phone: return self =~ .phone
    case .number(let digit): return self =~ .number(equal: digit)
    }
  }
}

// MARK: - remove
public extension String {

  enum RemoveMode: UInt {
    case emojis
    case illegal
  }

  /// 移除字符串中特定字符
  ///
  /// - Parameter state: 类型
  /// - Returns: 新串
  public func removed(_ modes: RemoveMode...) -> String {
    let res = filter { (item) -> Bool in
      if modes.contains(.illegal) && (String(item) =~ .illegal) { return false }
      if modes.contains(.emojis) && !String(item).extract(.emojis).isEmpty { return false }
      return true
    }
    return res
  }

}


