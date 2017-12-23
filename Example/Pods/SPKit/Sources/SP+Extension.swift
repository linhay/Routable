//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

class Extensions { }

public struct BLExtension<Base> {
  public let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public protocol ExtensionCompatible {
  associatedtype CompatibleType
  var sp: CompatibleType { get }
}

public extension ExtensionCompatible {
  public var sp: BLExtension<Self> {
    get { return BLExtension(self) }
  }
}

extension UIImage: ExtensionCompatible { }
extension UIView: ExtensionCompatible { }
extension UIViewController: ExtensionCompatible { }

public extension BLExtension where Base: UILabel{
  /// 改变字体大小 增加或者减少
  /// - Parameter offSet: 变化量
  public func change(with offSet: CGFloat) {
    let textFont = base.font.pointSize
    base.font = UIFont.systemFont(ofSize: textFont + offSet)
  }
}

public extension BLExtension where Base: NSLayoutConstraint {
  /// 改变Constant 增加或者减少
  /// - Parameter offSet: 变化量
  public func change(with offSet: CGFloat) {
    let nowConstant = base.constant
    base.constant += nowConstant
  }
}

public extension NSCoder{

  public func decodeString(forKey key: String) -> String{
    return decodeObject(forKey: key) as? String ?? ""
  }
  
}

