//
//  URL.swift
//  BLFoundation
//
//  Created by linhey on 2018/2/2.
//

import UIKit

public extension URL {

 /// 获取url参数集合
 public var querys: [String: String] {
    var dict = [String: String]()
    if let query = query {
      query.components(separatedBy: "&").forEach { (item) in
        let list = item.components(separatedBy: "=")
        if list.count == 2 {
          dict[list.first!] = list.last!
        }else if list.count > 2 {
          dict[list.first!] = list.dropLast().joined()
        }
      }
    }
    return dict
  }

}

