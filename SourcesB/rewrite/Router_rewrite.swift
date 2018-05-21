//
//  Router_b.swift
//  Routable
//
//  Created by BigL on 2017/9/8.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import SPRoutable

@objc(Router_rewrite)
public class Router_rewrite: NSObject {
 @objc func vc() -> UIViewController {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor.red
    return vc
  }
}
