//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import Foundation

public extension Float{
  public var cgFloat: CGFloat { return CGFloat(self) }
}

public extension CGFloat{
  /// 绝对值
  public var abs: CGFloat { return Swift.abs(self) }
  /// 向上取整
  public var ceil: CGFloat { return Foundation.ceil(self) }
  /// 向下取整
  public var floor: CGFloat { return Foundation.floor(self) }
  
  public var string: String { return description }
		
  public var int: Int { return Int(self) }
  public var float: Float { return Float(self) }
}
