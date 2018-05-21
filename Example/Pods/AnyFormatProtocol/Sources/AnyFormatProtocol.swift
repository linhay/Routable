//
//  AnyFormatProtocol.swift
//  Pods
//
//  Created by BigL on 2017/5/9.
//
//

import Foundation

public protocol AnyFormatProtocol { }

/// 处理模糊类型
///
/// - Parameter any: 待处理数据
/// - value: 默认值 default: 0
/// - Returns: Double
public extension AnyFormatProtocol{
  
  static func format(_ any: Any?, default value: Double = 0) -> Double {
    return AnyFormatModel.format(any, default: value)
  }
  
  static func format(_ any: Any?, default value: Float = 0) -> Float {
    return AnyFormatModel.format(any, default: value)
  }
  
  static func format(_ any: Any?, default value: CGFloat = 0) -> CGFloat {
    return AnyFormatModel.format(any, default: value)
  }
  
  static func format(_ any: Any?, default value: Int = 0) -> Int {
    return AnyFormatModel.format(any, default: value)
  }
  
  static func format(_ any: Any?, default value: Bool = false) -> Bool {
    return AnyFormatModel.format(any, default: value)
  }
  
  static func format(_ any: Any?, default value: String = "") -> String {
    return AnyFormatModel.format(any, default: value)
  }
  
  static func format<T>(_ any: Any?, default value: [T] = [T]()) -> [T] {
    return AnyFormatModel.format(any, default: value)
  }
  
  static func format<Key,Value>(_ any: Any?, default value: [Key: Value] = [Key: Value]()) -> [Key: Value] {
    return AnyFormatModel.format(any, default: value)
  }
  
}

/// 处理模糊类型
///
/// - Parameter any: 待处理数据
/// - value: 默认值 default: 0
/// - Returns: Double
public extension AnyFormatProtocol{

  func format(_ any: Any?, default value: Double = 0) -> Double {
    return AnyFormatModel.format(any, default: value)
  }

  func format(_ any: Any?, default value: Float = 0) -> Float {
    return AnyFormatModel.format(any, default: value)
  }

  func format(_ any: Any?, default value: CGFloat = 0) -> CGFloat {
    return AnyFormatModel.format(any, default: value)
  }

  func format(_ any: Any?, default value: Int = 0) -> Int {
    return AnyFormatModel.format(any, default: value)
  }

  func format(_ any: Any?, default value: Bool = false) -> Bool {
    return AnyFormatModel.format(any, default: value)
  }

  func format(_ any: Any?, default value: String = "") -> String {
    return AnyFormatModel.format(any, default: value)
  }

  func format<T>(_ any: Any?, default value: [T] = [T]()) -> [T] {
    return AnyFormatModel.format(any, default: value)
  }

  func format<Key,Value>(_ any: Any?, default value: [Key: Value] = [Key: Value]()) -> [Key: Value] {
    return AnyFormatModel.format(any, default: value)
  }
  
}

// MARK: - 优先取非0,非空的值
public extension AnyFormatProtocol {

  static func value<T: Comparable>(_ x: T, _ rest: T...) -> T {
    return AnyFormatModel.value(x, rest)
  }
  
  
  func value<T: Comparable>(_ x: T, _ rest: T...) -> T {
    return AnyFormatModel.value(x, rest)
  }
  
}


struct AnyFormatModel {

  static func format(_ any: Any?,
                     default value: Double = 0) -> Double {
    guard let p = any else { return value }
    if let v = p as? NSNumber { return v.doubleValue }
    if let v = p as? String { return v.double ?? value }
    return value
  }

  static func format(_ any: Any?,
                     default value: Float = 0) -> Float {
    guard let p = any else { return value }
    if let v = p as? NSNumber { return v.floatValue }
    if let v = p as? String { return v.float ?? value }
    return value
  }

  static func format(_ any: Any?,
                     default value: CGFloat = 0) -> CGFloat {
    guard let p = any else { return value }
    if let v = p as? NSNumber { return CGFloat(v.doubleValue) }
    if let v = p as? String {
      guard let c = v.double else { return value }
      return CGFloat(c)
    }
    return value
  }

  static func format(_ any: Any?,
                     default value: Int = 0) -> Int {
    guard let p = any else { return value }
    if let v = p as? NSNumber { return v.intValue }
    if let v = p as? String { return v.int ?? value }
    return value
  }

  static func format(_ any: Any?,
                     default value: Bool = false) -> Bool {
    guard let p = any else { return value }
    if let v = p as? NSNumber { return v.boolValue }
    if let v = p as? String { return v.bool ?? value }
    return value
  }

  static func format(_ any: Any?,
                     default value: String = "") -> String {
    guard let p = any else { return value }
    var str = ""
    if let v = p as? String { str = v }
    else { str = String(describing: p) }
    if str == "<null>" { return "" }
    return str
  }

  static func format<T>(_ any: Any?,
                        default value: [T] = [T]()) -> [T] {
    guard let p = any else { return value }
    if let v = p as? [T] { return v }
    return value
  }

  static func format<Key,Value>(_ any: Any?,
                                default value: [Key: Value] = [Key: Value]()) -> [Key: Value] {
    guard let p = any else { return value }
    if let v = p as? [Key: Value] { return v }
    return value
  }

}

extension AnyFormatModel {

  static func value<T: Comparable>(_ x: T, _ rest: [T]) -> T {
    let values = ([x] + rest).filter { (item) -> Bool in
      switch item {
      case let v as String where !v.isEmpty: return true
      default:
        guard let v = NumberFormatter().number(from: String(describing: item)) else { return false }
        return v.doubleValue != 0.0
      }
    }
    return values.first ?? x
  }

}


