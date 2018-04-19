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
      guard var attr = attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) else{ return textColor }
      guard let color = attr[NSAttributedStringKey.foregroundColor] as? UIColor else{ return textColor }
      return color
  }
    set {
      guard let placeholder = self.placeholder else { return }
      guard let color = newValue else { return }
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
      guard var attr = attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) else{ return font }
      guard let ft = attr[NSAttributedStringKey.font] as? UIFont else{ return font }
        return ft
  }
    set {
      guard let placeholder = self.placeholder else { return }
      guard let font = newValue else { return }
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
    get{ return leftView?.frame.size.width ?? 0 }
    set{
      checkLeftView()
      leftView?.frame.size.width = newValue
    }
  }
  
  /// 左边图标
  public var leftIcon: UIImage{
    get{
      guard let cgImage = self.leftView?.layer.contents else {
        return UIImage()
      }
      return UIImage(cgImage: cgImage as! CGImage)
    }
    set{
      checkLeftView()
      self.leftView?.layer.contents = newValue.cgImage
    }
  }
  
  /// 右边间距
  public var rightPadding: CGFloat{
    get{
      guard self.rightView != nil else {
        return 0
      }
      return self.frame.size.width
        - (self.rightView?.frame.origin.x)!
        - (self.rightView?.frame.size.width)!
    }
    set{
      checkRightView()
      self.rightView?.frame.size.width = newValue
    }
  }
  
  /// 右边图标
  public var rightIcon: UIImage{
    get{
      guard let cgImage = self.rightView?.layer.contents else {
        return UIImage()
      }
      return UIImage(cgImage: cgImage as! CGImage)
    }
    set{
      checkRightView()
      self.rightView?.layer.contents = newValue.cgImage
    }
  }
  
  private func checkLeftView() {
    self.leftViewMode = .always
    if self.leftView == nil {
      self.leftView = UIView(frame: CGRect(x: 0,y: 0,
                                           width: self.frame.size.height,
                                           height: self.frame.size.height))
    }
  }
  
  private func checkRightView() {
    self.rightViewMode = .always
    if self.rightView == nil {
      self.rightView = UIView(frame: CGRect(x: self.frame.size.width - self.frame.size.height,
                                            y: 0,
                                            width: self.frame.size.height,
                                            height: self.frame.size.height))
    }
  }
  
}

