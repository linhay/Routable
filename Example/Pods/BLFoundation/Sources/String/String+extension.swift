//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//
import Foundation

public extension String{
  /// 替换
  ///
  /// - Parameters:
  ///   - string: 代替换文本
  ///   - newString: 替换文本
  /// - Returns: 新串
  public func replacing(_ string: String, with newString: String) -> String {
    return replacingOccurrences(of: string, with: newString)
  }
}



// MARK: - 文本区域
public extension String{
  /// 获取字符串的Bounds
  ///
  /// - Parameters:
  ///   - font: 字体大小
  ///   - size: 字符串长宽限制
  /// - Returns: 字符串的Bounds
  public func bounds(font: UIFont,size: CGSize) -> CGRect {
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
    // 获取单行时候的内容的size
    let singleSize = (self as NSString).size(withAttributes: [NSAttributedStringKey.font:font])
    // 获取多行时候,文字的size
    let textSize = self.bounds(font: font, size: CGSize(width: width, height: CGFloat(MAXFLOAT))).size
    // 返回计算的行数
    return ceil(textSize.height / singleSize.height);
  }

}

