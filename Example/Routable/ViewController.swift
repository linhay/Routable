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

class ViewController: UITableViewController {
  let list = ["http://swift/vc",
              "http://swift/view",
              "http://swift/alert?ut=3",
              "http://swift/int",
              "http://swift/integer",
              "http://notice/noticeResult",
              "http://objc/vc",
              "http://objc/view",
              "http://objc/alert?ut=3",
              "http://objc/int",
              "http://objc/integer",
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


    if str.contains("vc"){
      guard let vc = Routable.viewController(url: str) else { return }
      navigationController?.pushViewController(vc, animated: true)
      return
    }

    if str.contains("view"){
      guard let v = Routable.view(url: str) else { return }
      navigationController?.view.addSubview(v)
      return
    }

    if str.contains("int"){
      guard let v = Routable.object(url: str) as Int? else { return }
      print(v)
      return
    }

    if str.contains("integer"){
      guard let v = Routable.object(url: str) as NSInteger? else { return }
      print(v)
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






