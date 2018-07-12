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
  
}

// MARK: - 返回值类型测试
extension Router_swift {
  
  @objc func double() -> Double {
    return 666.666
  }
  
  @objc  func int() -> Int {
    return 666
  }
  
  @objc  func string() -> String {
    return "swift-string"
  }
  
  @objc func cgfloat() -> CGFloat {
    return CGFloat(666.666)
  }
  
  @objc func boolValue() -> Bool {
    return true
  }
  
  @objc func dictionary() -> [String: Any] {
    return ["int": 666, "double": 666.666]
  }
  
  @objc func array() -> [Any] {
    return [0,1,2,3,4,5,6]
  }
  
  @objc func selector() -> Selector {
    return #selector(Router_swift.string);
  }
  
  @objc func vc() -> UIViewController {
    return UIViewController()
  }
  
}

// MARK: - 回调测试
extension Router_swift {
  
  @objc func asyncWithoutReturn(params: [String: Any],block: @escaping (_ dict:[String:Any]) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
      block(["asyncWithoutReturn": #function])
    }
  }
  
  @objc func asyncWithReturn(params: [String: Any],block: @escaping (_ dict:[String:Any]) -> Void) -> String {
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
      block(["asyncWithReturn": #function])
    }
    return #function
  }
  
}

// MARK: - 函数名匹配测试
extension Router_swift {
  
  @objc func nameTest() {
    print(#function)
  }
  
  @objc func nameTestWithParams() {
    print(#function)
  }
  
  @objc func nameTest(_ params: [String: Any]) {
    print(#function)
  }
  
  @objc func nameTest(params: [String: Any]) {
    print(#function)
  }

}
