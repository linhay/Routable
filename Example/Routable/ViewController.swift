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
  
  var urls = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Routable.classPrefix = "Router_"
    Routable.funcPrefix = ""
    
    testTypes.forEach { (item) in
      urls.append("http://objc/\(item)")
      urls.append("http://swift/\(item)")
    }
    
//    let sig = Proxy.methodSignature(swift, sel: #selector(Router_swift.int))
//    let inv = Invocation(methodSignature: sig)
//    inv?.target = swift
//    inv?.selector = #selector(Router_swift.int)
//    inv?.invoke()
//    var value: Int?
//    inv?.getReturnValue(&value)
//    print(value)
    
    
    //    RunTime.methods(from: Router_swift.self).forEach { (item) in
    //      print(method_getName(item))
    //    }
    //
    //    if let cls = NSClassFromString("Router_objc") {
    //      RunTime.methods(from: cls).forEach { (item) in
    //        print(method_getName(item))
    //      }
    //    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return urls.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    let url = urls[indexPath.item]
    cell.textLabel?.text = url
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let url = urls[indexPath.item]
    var ans = "无法获取返回值"
    
    let res = Routable.object(url: url, params: ["url": url]) { (item) in
      print(item)
      } as Any?
    
    if res != nil,let value = res {
      ans = String(describing: value)
    }
    
    let alert = UIAlertController(title: url,
                                  message: ans,
                                  preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "done",
                                  style: .cancel,
                                  handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
}






