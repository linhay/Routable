//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension CALayer {
  public var borderUIColor:UIColor? {
    set {
      self.borderColor = newValue?.cgColor
    }
    get {
      guard let cgColor = borderColor else { return nil }
      return UIColor(cgColor: cgColor) }
  }
}


