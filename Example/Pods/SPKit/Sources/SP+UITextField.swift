//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

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

