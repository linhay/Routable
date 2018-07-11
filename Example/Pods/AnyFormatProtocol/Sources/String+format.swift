//
//  Routable
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import Foundation
// MARK: - 转换
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
    if let num = NumberFormatter().number(from: self) { return num.boolValue }
    switch self.lowercased() {
    case "true","yes": return true
    case "false","no": return false
    default: return nil
    }
  }
}


extension AnyFormatModel {



}
