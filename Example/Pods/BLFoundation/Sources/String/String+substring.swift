//
//  sub.swift
//  Extensions
//
//  Created by BigL on 2017/7/8.
//

import Foundation

// MARK: - 索引
extension String {
  /// 获取指定字符串第一个字符在母串中的索引
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 索引
  func index(first str: String) -> String.Index? {
    let range = self.range(of: str)
    return range?.lowerBound
  }

  /// 获取指定字符串最后一个字符在母串中的索引
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 索引
  func index(last str: String) -> String.Index? {
    let range = self.range(of: str)
    return range?.upperBound
  }
}

// MARK: - 下标/区间截取
public extension String {
  /// 获取指定位置字符
  ///
  /// - Parameter index: 指定位置
  subscript(index: Int) -> String {
    if index < 0 || index >= count { return "" }
    let index = self.index(startIndex, offsetBy: String.IndexDistance(index))
    return String(self[index])
  }

  /// 截取: 区间内的子串
  ///
  /// - Parameter closedRange: 区间
  subscript(integerRange: Range<Int>) -> String {
    if isEmpty { return "" }
    var range: (start: Int, end: Int) = (integerRange.lowerBound,integerRange.upperBound)
    if range.start < 0 { range.start = 0 }
    if range.end >= count { range.end = count }
    if range.start > range.end { return "" }
    if range.start == range.end { return "" }
    let start = index(startIndex, offsetBy: range.start)
    let end = index(startIndex, offsetBy: range.end)
    return String(self[start..<end])
  }

  /// 截取: 区间内的子串
  ///
  /// - Parameter closedRange: 区间
  subscript(closedRange: CountableClosedRange<Int>) -> String {
    if isEmpty { return "" }
    var range: (start: Int, end: Int) = (closedRange.lowerBound,closedRange.upperBound)
    if range.start < 0 { range.start = 0 }
    if range.end >= count { range.end = count - 1 }
    if range.start > range.end { return "" }
    if range.start == range.end { return self[range.start] }
    let start = index(startIndex, offsetBy: range.start)
    let end = index(startIndex, offsetBy: range.end)
    return String(self[start...end])
  }
}

// MARK: - 截取
public extension String {

  /// 截取: 获取指定字符串前的字符
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 子串
  func substring(before str: String) -> String {
    guard let index = self.index(first: str) else { return "" }
    return String(self[..<index])
  }

  /// 截取: 获取指定字符串后的字符
  ///
  /// - Parameter str: 指定字符串
  /// - Returns: 子串
  func substring(after str: String) -> String {
    guard let index = self.index(last: str) else { return "" }
    let str = String(self[index...])
    return str
  }
}
