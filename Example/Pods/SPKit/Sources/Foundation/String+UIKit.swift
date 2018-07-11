//
//  SPKit
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

import UIKit

// MARK: - 文本区域
public extension String{
  /// 获取字符串的Bounds
  ///
  /// - Parameters:
  ///   - font: 字体大小
  ///   - size: 字符串长宽限制
  /// - Returns: 字符串的Bounds
  public func bounds(font: UIFont,size: CGSize) -> CGRect {
    if self.isEmpty { return CGRect.zero }
    let attributes = [NSAttributedStringKey.font: font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
    return rect
  }
  
  
  /// 获取字符串的Bounds
  ///
  /// - parameter font:    字体大小
  /// - parameter size:    字符串长宽限制
  /// - parameter margins: 头尾间距
  /// - parameter space:   内部间距
  ///
  /// - returns: 字符串的Bounds
  public func size(with font: UIFont,
                   size: CGSize,
                   margins: CGFloat = 0,
                   space: CGFloat = 0) -> CGSize {
    if self.isEmpty { return CGSize.zero }
    var bound = self.bounds(font: font, size: size)
    let rows = self.rows(font: font, width: size.width)
    bound.size.height += margins * 2
    bound.size.height += space * (rows - 1)
    return bound.size
  }
  
  /// 文本行数
  ///
  /// - Parameters:
  ///   - font: 字体
  ///   - width: 最大宽度
  /// - Returns: 行数
  public func rows(font: UIFont,width: CGFloat) -> CGFloat {
    if self.isEmpty { return 0 }
    // 获取单行时候的内容的size
    let singleSize = (self as NSString).size(withAttributes: [NSAttributedStringKey.font:font])
    // 获取多行时候,文字的size
    let textSize = self.bounds(font: font, size: CGSize(width: width, height: CGFloat(MAXFLOAT))).size
    // 返回计算的行数
    return ceil(textSize.height / singleSize.height);
  }
  
}

