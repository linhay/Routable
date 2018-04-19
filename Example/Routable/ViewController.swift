//
//  ViewController.swift
//  Routable
//
//  Created by bigL055 on 06/10/2017.
//  Copyright (c) 2017 bigL055. All rights reserved.
//

import UIKit
import SPRoutable
import BModules
import RoutableAssist
//import AModules

class ViewController: UITableViewController {
  
  
  enum TestType: String {
    case resultType = "返回值类型"
  }
  
  var sections = [TestType: [String]]()
  
  let testTypes = ["int",
                   "double",
                   "string",
                   "cgfloat",
                   "boolValue",
                   "dictionary",
                   "array",
                   "selector",
                   "block",
                   "standard1"]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Routable.funcPrefix = ""
    tableView.sp.register(URLUnitCell.self)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return testTypes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.sp.dequeueCell(indexPath) as URLUnitCell
    cell.selAction = testTypes[indexPath.item]
    return cell
  }
  
}






