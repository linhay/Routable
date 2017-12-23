//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension CGRect {
  
  /// X
  public var x: CGFloat {
    set { self.origin.x = newValue }
    get { return self.origin.x }
  }
  
  /// Y
  public var y: CGFloat {
    set { self.origin.y = newValue }
    get { return self.origin.y }
  }
}
