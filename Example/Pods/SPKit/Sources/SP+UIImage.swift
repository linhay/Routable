//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

// MARK: - 初始化
public extension UIImage{

  /// 返回一张没有被渲染图片
  public class func initWith(original name: String) -> UIImage? {
    return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
  }

  /// 图像处理: 裁圆
  ///
  /// - Parameter round: 需处理的图片/图片名称
  /// - Returns: 新图
  public convenience init?(round name: String) {
    let img = UIImage(named: name)?.sp.roundImg
    guard let cgImg = img?.cgImage else { return nil }
    self.init(cgImage: cgImg)
  }

  /// 从网络获取Image
  public convenience init?(urlStr: String) {
    guard let url = URL(string: urlStr) else {
      self.init(data: Data())
      return
    }
    guard let data = try? Data(contentsOf: url) else {
      print("UIImage: 该URL资源不是Image类型 \(urlStr)")
      self.init(data: Data())
      return
    }
    self.init(data: data)
  }

  /// 获取指定颜色的图片
  ///
  /// - Parameters:
  ///   - color: UIColor
  ///   - size: 图片大小
  public convenience init?(color: UIColor,
                           size: CGSize = CGSize(width: 1, height: 1)) {
    if size.width <= 0 || size.height <= 0 { return nil }
    let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    guard let context: CGContext = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return nil
    }
    context.setFillColor(color.cgColor)
    context.fill(rect)
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
      UIGraphicsEndImageContext()
      return nil
    }
    UIGraphicsEndImageContext()
    guard let cgImg = image.cgImage else { return nil }
    self.init(cgImage: cgImg)
  }

}

public extension BLExtension where Base: UIImage{

  /// 图片尺寸: Bytes
  public var sizeAsBytes: Int
  { return UIImageJPEGRepresentation(base, 1)?.count ?? 0 }

  /// 图片尺寸: KB
  public var sizeAsKB: Int {
    let sizeAsBytes = self.sizeAsBytes
    return sizeAsBytes != 0 ? sizeAsBytes / 1024: 0 }

  /// 图片尺寸: MB
  public var sizeAsMB: Int {
    let sizeAsKB = self.sizeAsKB
    return sizeAsBytes != 0 ? sizeAsKB / 1024: 0 }

}

// MARK: - 类方法
public extension BLExtension where Base: UIImage{
  /// 返回一张没有被渲染图片
  public var original: UIImage { return base.withRenderingMode(.alwaysOriginal) }
  public var roundImg: UIImage {
    return base.sp.round(radius: base.size.height * 0.5,
                         corners: UIRectCorner.allCorners,
                         borderWidth: 0,
                         borderColor: nil,
                         borderLineJoin: .miter)
  }

}

// MARK: - 图片处理
public extension BLExtension where Base: UIImage{

  /// 裁剪对应区域
  ///
  /// - Parameter bound: 裁剪区域
  /// - Returns: 新图
  public func crop(bound: CGRect) -> UIImage {
    guard base.size.width > bound.origin.x else {
      print("UIImage: 裁剪宽度超出图片宽度")
      return base
    }
    guard base.size.height > bound.origin.y else {
      print("UIImage: 裁剪高度超出图片高度")
      return base
    }
    let scaledBounds: CGRect = CGRect(x: bound.origin.x * base.scale,
                                      y: bound.origin.y * base.scale,
                                      width: bound.size.width * base.scale,
                                      height: bound.size.height * base.scale)
    let imageRef = base.cgImage?.cropping(to: scaledBounds)
    let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: base.scale, orientation: UIImageOrientation.up)
    return croppedImage
  }

  /// 图像处理: 裁圆
  /// - Parameters:
  /// - radius: 圆角大小
  /// - corners: 圆角区域
  /// - borderWidth: 描边大小
  /// - borderColor: 描边颜色
  /// - borderLineJoin: 描边类型
  /// - Returns: 新图
  public func round(radius: CGFloat,
                    corners: UIRectCorner = .allCorners,
                    borderWidth: CGFloat = 0,
                    borderColor: UIColor? = nil,
                    borderLineJoin: CGLineJoin = .miter) -> UIImage {
    var corners = corners

    if corners != UIRectCorner.allCorners {
      var  tmp: UIRectCorner = UIRectCorner(rawValue: 0)
      if (corners.rawValue & UIRectCorner.topLeft.rawValue) != 0
      { tmp = UIRectCorner(rawValue: tmp.rawValue | UIRectCorner.bottomLeft.rawValue) }
      if (corners.rawValue & UIRectCorner.topLeft.rawValue) != 0
      { tmp = UIRectCorner(rawValue: tmp.rawValue | UIRectCorner.bottomRight.rawValue) }
      if (corners.rawValue & UIRectCorner.bottomLeft.rawValue) != 0
      { tmp = UIRectCorner(rawValue: tmp.rawValue | UIRectCorner.topLeft.rawValue) }
      if (corners.rawValue & UIRectCorner.bottomRight.rawValue) != 0
      { tmp = UIRectCorner(rawValue: tmp.rawValue | UIRectCorner.topRight.rawValue) }
      corners = tmp
    }
    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    guard let context: CGContext = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return UIImage()
    }
    let rect: CGRect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
    context.scaleBy(x: 1, y: -1)
    context.translateBy(x: 0, y: -rect.height)
    let minSize: CGFloat = min(base.size.width, base.size.height)

    if borderWidth < minSize * 0.5{
      let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth),
                              byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: borderWidth))

      path.close()
      context.saveGState()
      path.addClip()
      guard let cgImage = base.cgImage else {
        UIGraphicsEndImageContext()
        return UIImage()
      }
      context.draw(cgImage, in: rect)
      context.restoreGState()
    }

    if (borderColor != nil && borderWidth < minSize / 2 && borderWidth > 0) {
      let strokeInset: CGFloat = (floor(borderWidth * base.scale) + 0.5) / base.scale
      let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
      let strokeRadius: CGFloat = radius > base.scale / 2 ? CGFloat(radius - base.scale / 2): 0
      let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
      path.close()
      path.lineWidth = borderWidth
      path.lineJoinStyle = borderLineJoin
      borderColor?.setStroke()
      path.stroke()
    }
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
      UIGraphicsEndImageContext()
      return UIImage()
    }
    UIGraphicsEndImageContext()
    return image
  }

  /// 根据宽度获取对应高度
  ///
  /// - Parameter width: 宽度
  /// - Returns: 新高度
  func aspectHeight(with width: CGFloat) -> CGFloat {
    return (width * base.size.height) / base.size.width
  }

  /// 根据高度获取对应宽度
  ///
  /// - Parameter height: 高度
  /// - Returns: 宽度
  func aspectWidth(with height: CGFloat) -> CGFloat {
    return (height * base.size.width) / base.size.height
  }

  /// 重设图片大小
  ///
  /// - Parameter size: 新的尺寸
  /// - Returns: 新图
  public func reSize(size: CGSize)->UIImage {
    UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.main.scale)
    base.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return reSizeImage
  }

  /// 根据宽度重设大小
  ///
  /// - Parameter width: 宽度
  /// - Returns: 新图
  public func resize(width: CGFloat) -> UIImage {
    let aspectSize = CGSize (width: width, height: aspectHeight(with: width))

    UIGraphicsBeginImageContext(aspectSize)
    base.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return img!
  }

  /// 根据高度重设大小
  ///
  /// - Parameter height: 高度
  /// - Returns: 新图
  public func resize(height: CGFloat) -> UIImage {
    let aspectSize = CGSize (width: aspectWidth(with: height), height: height)

    UIGraphicsBeginImageContext(aspectSize)
    base.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return img!
  }

}

// MARK: - 尺寸相关
public extension BLExtension where Base: UIImage{

  /// 等比率缩放
  ///
  /// - Parameter multiple: 倍数
  /// - Returns: 新图
  public func scale(multiple: CGFloat)-> UIImage {
    let newSize = CGSize(width: base.size.width * multiple, height: base.size.height * multiple)
    return reSize(size: newSize)
  }

  /// 压缩图片
  ///
  /// - Parameter rate: 压缩比率
  /// - Returns: 新图
  public func compress(rate: CGFloat) -> Data? {
    return UIImageJPEGRepresentation(base, rate)
  }
}
