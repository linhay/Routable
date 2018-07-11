//
//  SPKit
//
//  Copyright (c) 2017 linhay - https://  github.com/linhay
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

public extension UIColor{
  
  /// 随机色
  public class var random: UIColor {
    get{
      return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0,
                     green: CGFloat(arc4random_uniform(255)) / 255.0,
                     blue: CGFloat(arc4random_uniform(255)) / 255.0,
                     alpha: 1)
    }
  }
  
  /// 设置透明度
  ///
  /// - Parameter alpha: 透明度
  /// - Returns: uicolor
  public func with(alpha: CGFloat) -> UIColor {
    return self.withAlphaComponent(alpha)
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
  /// - Parameter str: "#666666" / "0X666666" / "0x666666"
  convenience init(str: String){
    var cString = str.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if cString.hasPrefix("0X") { cString = String(cString[String.Index(encodedOffset: 2)...]) }
    if cString.hasPrefix("#") { cString = String(cString[String.Index(encodedOffset: 1)...]) }
    if cString.count != 6 {
      self.init(red: 1, green: 1, blue: 1, alpha: 1)
      return
    }
    
    let rStr = cString[String.Index(encodedOffset: 0)..<String.Index(encodedOffset: 2)]
    let gStr = cString[String.Index(encodedOffset: 2)..<String.Index(encodedOffset: 4)]
    let bStr = cString[String.Index(encodedOffset: 4)..<String.Index(encodedOffset: 6)]
    
    var r: UInt32 = 0x0
    var g: UInt32 = 0x0
    var b: UInt32 = 0x0
    Scanner(string: String(rStr)).scanHexInt32(&r)
    Scanner(string: String(gStr)).scanHexInt32(&g)
    Scanner(string: String(bStr)).scanHexInt32(&b)
    
    self.init(
      red: CGFloat(r) / 255.0,
      green: CGFloat(g) / 255.0,
      blue: CGFloat(b) / 255.0,
      alpha: 1
    )
  }
  
}
