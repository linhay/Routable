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

public extension UITextField{
  
  /// 占位文字颜色
  public var placeholderColor: UIColor? {
    get{
      guard var attr = attributedPlaceholder?.attributes(at: 0, effectiveRange: nil),
        let color = attr[NSAttributedStringKey.foregroundColor] as? UIColor else{ return textColor }
      return color
    }
    set {
      guard let placeholder = self.placeholder, let color = newValue else { return }
      if var attr = attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) {
        attr[NSAttributedStringKey.foregroundColor] = newValue
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
        return
      }
      
      let attr = [NSAttributedStringKey.foregroundColor: color]
      attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
    }
  }
  
  /// 占位文字字体
  public var placeholderFont: UIFont? {
    get{
      guard var attr = attributedPlaceholder?.attributes(at: 0, effectiveRange: nil),
        let ft = attr[.font] as? UIFont else{ return font }
      return ft
    }
    set {
      guard let placeholder = self.placeholder, let font = newValue else { return }
      if var attr = attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) {
        attr[NSAttributedStringKey.font] = newValue
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
        return
      }
      let attr = [NSAttributedStringKey.font: font]
      attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attr)
    }
  }
  
  /// 左边间距
  public var leftPadding: CGFloat{
    get{
      return leftView?.frame.width ?? 0
    }
    set{
      guard let view = leftView else {
        self.leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: bounds.height))
        return
      }
      view.bounds.size.width = newValue
    }
  }
  
  /// 右边间距
  public var rightPadding: CGFloat{
    get{
      return rightView?.frame.width ?? 0
    }
    set{
      guard let view = rightView else {
        self.rightViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: bounds.height))
        return
      }
      view.bounds.size.width = newValue
    }
  }
  
}

