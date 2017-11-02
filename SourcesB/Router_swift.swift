//
//  Router_b.swift
//  Routable
//
//  Created by BigL on 2017/9/8.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import SPRoutable

@objc(Router_swift)
public class Router_swift: NSObject {
  var flag = true

 @objc func router_vc(params:[String: Any]) -> UIViewController {
    let vc = SwiftViewController()
    vc.view.backgroundColor = UIColor.blue
    return vc
  }

 @objc func router_view() -> UIView {
    let view = UIView()
    view.frame = CGRect(x: 0, y: 300, width: 300, height: 300)
    view.backgroundColor = flag ? UIColor.red : UIColor.blue
    flag = !flag
    return view
  }

 @objc func router_alert(params: [String: Any] = [:]) {
    let alert = UIAlertController()
    alert.title = #function
    alert.message = params.description
    let action = UIAlertAction(title: "确定",
                               style: UIAlertActionStyle.cancel,
                               handler: nil)
    alert.addAction(action)
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
  }

  @objc func router_object() -> NSDictionary {
    return ["s": 2]
  }

  @objc func router_notice() {
    print(#function + "router_notice")
  }

}
