//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import Foundation

// MARK: - Properties
public extension Character {
  /// 转换: int
  public var int: Int? {
    return Int(String(self))
  }
  
  /// 转换: string
  public var string: String {
    return String(self)
  }
}
