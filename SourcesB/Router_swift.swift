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
    vc.view.backgroundColor = flag ? UIColor.red : UIColor.blue
    vc.title = #function
    flag = !flag
    return vc

  }

  @objc func router_view(params:[String: Any]) -> UIView {
    let view = UIView()
    view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20)
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

  @objc func router_int(params: [String: Any] = [:]) -> Int {
    return flag ? 100 : 200
  }

  @objc func router_integer(params: [String: Any] = [:]) -> NSInteger {
    let int = NSInteger(bitPattern: flag ? 100 : 200)
    return int
  }

  @objc func router_string(params: [String: Any] = [:]) -> String {
    return #function
  }

  @objc func router_noticeResult() {
    router_alert(params: ["notice": #function])
  }

}
