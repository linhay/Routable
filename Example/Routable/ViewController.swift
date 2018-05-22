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
import SPKit
//import AModules

class ViewController: UITableViewController {
  
  var resultTests = [(title: "获取 int 类型返回值",
                      objc: "sp://objc/int",
                      swift: "sp://swift/int"),
                     (title: "获取 double 类型返回值",
                      objc: "sp://objc/double",
                      swift: "sp://swift/double"),
                     (title: "获取 string/NSString 类型返回值",
                      objc: "sp://objc/string",
                      swift: "sp://swift/string"),
                     (title: "获取 cgfloat 类型返回值",
                      objc: "sp://objc/cgfloat",
                      swift: "sp://swift/cgfloat"),
                     (title: "获取 bool 类型返回值",
                      objc: "sp://objc/boolValue",
                      swift: "sp://swift/boolValue"),
                     (title: "获取 dictionary 类型返回值",
                      objc: "sp://objc/dictionary",
                      swift: "sp://swift/dictionary"),
                     (title: "获取 selector 类型返回值",
                      objc: "sp://objc/selector",
                      swift: "sp://swift/selector"),
                     (title: "获取 viewcontroller 类型返回值",
                      objc: "sp://objc/vc",
                      swift: "sp://swift/vc"),
                     (title: "获取 async/异步 返回值",
                      objc: "sp://objc/async",
                      swift: "sp://swift/async?title=title")]
  
  var rewriteRule = ["http://rewrite/vc?title=rewrite&test=1" : "http://web/vc?url=https://m.baidu.com/s&word=$title&title=vcName"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Routable"
    Routable.funcPrefix = ""
    Routable.rewrite(rules:rewriteRule)
    tableView.sp.register(URLReturnValueCell.self)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resultTests.count + 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.sp.dequeueCell(indexPath) as URLReturnValueCell
    switch indexPath.item {
    case 0..<resultTests.count:
      let item = resultTests[indexPath.item]
      cell.label.text = item.title
      cell.leftBtn.setTitle(item.objc, for: .normal)
      cell.rightBtn.setTitle(item.swift, for: .normal)
      cell.leftBtn.add(for: .touchUpInside) {
        let value = Routable.object(str: item.objc,params: ["param1" : "title"]) { (result) in
          self.alert(title: item.title, message: String(describing: result))
        }
        
        guard let result = value else { return }
        self.alert(title: item.title, message: String(describing: result))
      }
      cell.rightBtn.add(for: .touchUpInside) {
        let value = Routable.object(str: item.swift,params: ["param1" : "title"]) { (result) in
          self.alert(title: item.title, message: String(describing: result))
        }
        
        guard let result = value else { return }
        self.alert(title: item.title, message: String(describing: result))
      }
    default:
      cell.label.text =
      """
      RewriteRule:
      http://rewrite/vc?title=rewrite&test=1
      http://web/vc?url=https://m.baidu.com/s&word=$title&title=vcName
      [先执行覆盖: title=vcName, 后执行新增: word=$title]
      
      RewriteAfter:
      http://web/vc
      ?url=https://m.baidu.com/s
      &word=vcName
      &title=vcName
      &test=1
      """
      
      cell.leftBtn.setTitle(self.rewriteRule.keys.first!, for: .normal)
      cell.rightBtn.setTitle(self.rewriteRule.keys.first!, for: .normal)
      
      cell.leftBtn.add(for: .touchUpInside) {
        Routable.rewrite(rules: self.rewriteRule)
        guard let vc = Routable.viewController(str: self.rewriteRule.keys.first!) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
      }
      
      cell.rightBtn.add(for: .touchUpInside) {
        Routable.rewrite(rules: [:])
        guard let vc = Routable.viewController(str: self.rewriteRule.keys.first!) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    return cell
  }
  
  func alert(title: String, message: String) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .actionSheet)
    
    let action = UIAlertAction(title: "done",
                               style: .cancel,
                               handler: nil)
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
}






