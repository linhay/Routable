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
import BLFoundation

public extension BLExtension where Base: UILabel {
  /// 改变字体大小 增加或者减少
  public func change(font offSet: CGFloat) {
    base.font = UIFont(name: base.font.fontName, size: base.font.pointSize + offSet)
  }
  
}

// MARK: - runtime and swizzling
extension UILabel {
  fileprivate static var once: Bool = false
  fileprivate class func swizzig() {
    if once == false {
      once = true
      RunTime.exchangeMethod(selector: #selector(UILabel.drawText(in:)),
                             replace: #selector(UILabel.sp_drawText(in:)),
                             class: UILabel.self)
    }
  }
  
  fileprivate struct SwzzlingKeys {
    static var textInset = UnsafeRawPointer(bitPattern: "label_textInset".hashValue)
  }
}

// MARK: - textInset
extension UILabel {
  
  public var textInset: UIEdgeInsets {
    get{
      if let eventInterval = objc_getAssociatedObject(self,
                                                      UILabel.SwzzlingKeys.textInset!) as? UIEdgeInsets {
        return eventInterval
      }
      return UIEdgeInsets.zero
    }
    set {
      UILabel.swizzig()
      objc_setAssociatedObject(self,
                               UILabel.SwzzlingKeys.textInset!,
                               newValue as UIEdgeInsets,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      drawText(in: bounds)
    }
  }
  
  @objc fileprivate func sp_drawText(in rect: CGRect) {
    let rect = CGRect(x: bounds.origin.x + textInset.left,
                      y: bounds.origin.y + textInset.top,
                      width: bounds.size.width - textInset.left - textInset.right,
                      height: bounds.size.height - textInset.top - textInset.bottom)
    sp_drawText(in: rect)
  }
  
}
