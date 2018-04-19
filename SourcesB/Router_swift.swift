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

// 返回值类型测试
extension Router_swift {
  
  @objc func double() -> Double {
    return 666.666
  }
  
  @objc public func int() -> Int {
    return 666
  }
  
  @objc public func string() -> String {
    return "swift-string"
  }
  
  @objc func cgfloat() -> CGFloat {
    return CGFloat(3.14)
  }
  
  @objc func boolValue() -> Bool {
    return true
  }
  
  @objc func dictionary() -> [String: Any] {
    return ["int": 0, "double": 3.14]
  }
  
  @objc func array() -> [Any] {
    return [0,1,2,3,4,5,6]
  }
  
  @objc func selector() -> Selector {
    return #selector(Router_swift.string);
  }
  
}


extension Router_swift {
  
  @objc func block(block: ((_ str: String)->())?) {
    block?("block")
  }
  
  @objc public func standard1(params: [String: Any]?, id: Int) -> [String: Any]? {
    Routable.callback(id: id, params: ["standard1": "block"], isRemove: true)
    return ["standard1": "return"]
  
  }
  
}

// 参数类型测试
extension Router_swift {
  
  /// 普通格式
  @objc func params1(params: String) {
    print("params1")
  }
  
  /// 普通格式(前缀相同)
  @objc func params1Test(params: String) {
    print("params1Test")
  }
  
  
  /// 重复函数名 + 多参数格式 (不匹配该类型)
  @objc func params1(params: String,id: String) {
    print("params1")
  }
  
  /// 匿名格式
  @objc func params2(_ params: String) {
    print("params2")
  }
  
  /// 默认参数格式
  @objc func params3(params: String = "") {
    print("params3")
  }
  
  /// 匿名+默认参数格式
  @objc func params4(_ params: String = "") {
    print("params4")
  }
  
}
