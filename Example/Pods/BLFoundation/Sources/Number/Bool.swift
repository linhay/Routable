//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import UIKit

public extension Bool {
  /// Bool转Int  value: 1: 0
  public var int: Int { return self ? 1: 0 }
  /// Bool转String   value: "1": "0"
  public var string: String { return description }
}
