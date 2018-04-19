//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension UIView{

  /// 圆角
  public var cornerRadius: CGFloat {
    get{ return self.layer.cornerRadius }
    set{
      self.layer.cornerRadius = newValue
      self.layer.masksToBounds = true
    }
  }

  /// 边框宽度
  public var borderWidth: CGFloat {
    get{ return self.layer.borderWidth }
    set{ self.layer.borderWidth = newValue }
  }

  /// 边框颜色
  public var borderColor: UIColor  {
    get{
      guard let temp: CGColor = self.layer.borderColor else {
        return UIColor.clear
      }
      return UIColor(cgColor: temp)
    }
    set { self.layer.borderColor = newValue.cgColor }
  }

  /// 背景图片
  public var cgImage: UIImage {
    get{
      guard let temp: Any = self.layer.contents else {
        return UIImage()
      }
      return UIImage.init(cgImage: temp as! CGImage)
    }
    set { self.layer.contents = newValue.cgImage }
  }

}

public extension BLExtension where Base: UIView{

  /// 返回目标View所在的控制器UIViewController
  public var viewController: UIViewController? {
    get{
      var next:UIView? = base
      repeat{
        if let vc = next?.next as? UIViewController{ return vc }
        next = next?.superview
      }while next != nil
      return nil
    }
  }

  /// 对当前View快照
  public var snapshoot: UIImage{
    get{
      UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
      base.layer.render(in: UIGraphicsGetCurrentContext()!)
      guard let snap = UIGraphicsGetImageFromCurrentImageContext() else {
        UIGraphicsEndImageContext()
        return UIImage()
      }
      UIGraphicsEndImageContext()
      return snap
    }
  }

  /// 移除View全部子控件
  public func removeSubviews() {
    for _ in 0..<base.subviews.count {
      base.subviews.last?.removeFromSuperview()
    }
  }

  /// 设置LayerShadow,offset,radius
  public func setShadow(color: UIColor, offset: CGSize,radius: CGFloat) {
    base.layer.shadowColor = color.cgColor
    base.layer.shadowOffset = offset
    base.layer.shadowRadius = radius
    base.layer.shadowOpacity = 1
    base.layer.shouldRasterize = true
    base.layer.rasterizationScale = UIScreen.main.scale
  }
  
}

