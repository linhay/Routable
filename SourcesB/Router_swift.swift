//
//  Router_b.swift
//  Routable
//
//  Created by BigL on 2017/9/8.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

@objc(Router_swift)
class Router_swift: NSObject {
  var flag = true

  func router_a(params:[String: Any]) -> UIViewController {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor.blue
    return vc
  }

  func router_b() -> UIView {
    let view = UIView()
    view.frame = CGRect(x: 0, y: 300, width: 300, height: 300)
    view.backgroundColor = flag ? UIColor.red : UIColor.blue
    flag = !flag
    return view
  }

  func router_c(params: [String: Any] = [:]) {
    let alert = UIAlertController()
    alert.title = #function
    alert.message = params.description
    let action = UIAlertAction(title: "确定",
                               style: UIAlertActionStyle.cancel,
                               handler: nil)
    alert.addAction(action)
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}
