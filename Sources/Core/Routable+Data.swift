//
//  Routable+Data.swift
//  AModules
//
//  Created by linhey on 2018/4/19.
//

import UIKit

class RoutableData {
  var id: String = ""
  var targetName = ""
  var selName = ""
  var target: NSObject?
  var sel: Selector?
  var params = [String: Any]()
  var returnType: ObjectType = .unknown
  var isBadURL = false
}
