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

  @objc func router_vc(params:[String: Any]) -> UIViewController {
    let vc = SwiftViewController()
    vc.title = #function
    return vc
  }

  @objc func router_view(params:[String: Any]) -> UIView {
    let view = UIView()
    view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20)
    return view
  }

  @objc func router_async(params:[String: Any], id: String){
    Routable.callback(id: id, params: ["hello": "world"], isRemove: true)
  }

  @objc func router_async2(params:[String: Any], id: String){
    Routable.callback(id: id, params: ["hello": "world"], isRemove: true)
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
    return 123456789
  }
  
  @objc func router_intWith2(params: [String: Any] = [:]) -> Int {
    return 12345
  }
  
  @objc func router_double(params: [String: Any] = [:]) -> Double {
    return 11.11
  }

  @objc func router_integer(params: [String: Any] = [:]) -> NSInteger {
    let int = NSInteger(bitPattern: UInt(arc4random_uniform(UInt32.max)))
    return int
  }

  @objc func router_string(params: [String: Any] = [:]) -> String {
    return #function
  }

  @objc func router_noticeResult() {
    router_alert(params: ["notice": #function])
  }

}
