//
//  String+operator.swift
//  Pods-BLFoundation_Example
//
//  Created by BigL on 2017/9/15.
//

import Foundation

infix operator =~

// MARK: - 操作符
public extension String{

  static public func*(str: String, num: Int) -> String {
    let stringBuilder = Array(repeating: str, count: num)
    return stringBuilder.joined()
  }

  static public func*(num: Int,str: String) -> String {
    return  str * num
  }

  static public func =~(lhs: String, rhs: String) -> Bool {
    return !Regex(rhs).matches(input: lhs).isEmpty
  }

  static public func =~(lhs: String, rhs: RegexPattern) -> Bool {
    return !Regex(rhs).matches(input: lhs).isEmpty
  }

}

