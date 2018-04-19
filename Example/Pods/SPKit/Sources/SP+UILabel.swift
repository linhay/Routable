//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit
import BLFoundation

extension UILabel{
  /// 改变字体大小 增加或者减少
 public func change(font offSet: CGFloat) {
    font = UIFont(name: font.fontName, size: font.pointSize + offSet)
  }

}

// MARK: - runtime and swizzling
extension UILabel {
  private static var once: Bool = false
  class func swizzling() {
    if once == false {
      once = true
    RunTime.exchangeMethod(selector: #selector(UILabel.drawText(in:)),
                           replace: #selector(UILabel.sp_drawText(in:)),
                           class: UILabel.self)
    }
  }

  fileprivate struct SwzzlingKeys {
    static var textInset = UnsafeRawPointer.init(bitPattern: "label_textInset".hashValue)
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
        objc_setAssociatedObject(self,
                                 UILabel.SwzzlingKeys.textInset!,
                                 newValue as UIEdgeInsets,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        drawText(in: bounds)
      }
    }

  @objc func sp_drawText(in rect: CGRect) {
    let rect = CGRect(x: bounds.origin.x + textInset.left,
                      y: bounds.origin.y + textInset.top,
                      width: bounds.size.width - textInset.left - textInset.right,
                      height: bounds.size.height - textInset.top - textInset.bottom)
    sp_drawText(in: rect)
  }

}
