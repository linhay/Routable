//
//  CView.swift
//  Routable_Example
//
//  Created by BigL on 2017/9/8.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class CView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.darkText
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
