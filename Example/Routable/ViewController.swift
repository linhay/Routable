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
import AModules
import SPKit

class ViewController: UITableViewController {
  let list = ["http://swift/async",
              "http://swift/vc",
              "http://swift/view",
              "http://swift/alert?ut=3",
              "http://swift/int",
              "http://swift/integer",
              "http://swift/string",
              "http://swift/double",
              "http://notice/noticeResult",
              "http://objc/vc",
              "http://objc/view",
              "http://objc/alert?ut=3",
              "http://objc/int",
              "http://objc/integer",
              "http://objc/string",
              "http://notice/noticeResult"]


  override func viewDidLoad() {
    super.viewDidLoad()
    RunTime.methods(from: Router_swift.self).forEach { (item) in
      print(method_getName(item))
    }

    if let cls = NSClassFromString("Router_objc") {
      RunTime.methods(from: cls).forEach { (item) in
        print(method_getName(item))
      }
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.textLabel?.text = list[indexPath.item]
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let str = list[indexPath.item]

    if str.contains("async") {
      Routable.object(url: str, params: [:],call: { (result) in
        Routable.executing(url: "http://swift/alert?String=async")
      })
    }
    
    if str.contains("double") {
      guard let v = Routable.object(url: str) as Int? else { return }
      Routable.executing(url: "http://swift/double?double=\(v)")
      return
    }

    if str.contains("vc"){
      guard let vc = Routable.viewController(url: str) else { return }
      vc.view.backgroundColor = UIColor.random
      navigationController?.pushViewController(vc, animated: true)
      return
    }

    if str.contains("view"){
      guard let v = Routable.view(url: str) else { return }
      navigationController?.view.subviews.forEach({ (item) in
        if item.frame == v.frame { item.removeFromSuperview() }
      })
      v.backgroundColor = UIColor.random
      navigationController?.view.addSubview(v)
      return
    }

    if str.contains("int"){
      guard let v = Routable.object(url: str) as Int? else { return }
      Routable.executing(url: "http://swift/alert?Int=\(v)")
      return
    }

    if str.contains("integer"){
      guard let v = Routable.object(url: str) as NSInteger? else { return }
      Routable.executing(url: "http://swift/alert?NSInteger=\(v)")
      return
    }

    if str.contains("string"){
      guard let v = Routable.object(url: str) as String? else { return }
      Routable.executing(url: "http://swift/alert?String=\(v)")
      return
    }

    if str.contains("noticeResult"){
      Routable.notice(url: str)
    }

    if str.contains("alert"){
      Routable.executing(url: str)
      return
    }

  }

}






