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
  let list = ["http://objc/vc",
              "http://swift/vc",
              "http://swift/view",
              "http://swift/alert?ut=3",
              "http://swift/object",
              "http://notice/notice"]


  override func viewDidLoad() {
    super.viewDidLoad()
    RunTime.methods(from: Router_swift.self).forEach { (item) in
      print(method_getName(item))
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
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
      tableView.addSubview(v)
      return
    }

    if str.contains("object"){
      guard let v: NSDictionary = Routable.object(url: str) else { return }
      print(v)
      return
    }

    if str.contains("alert"){
      Routable.executing(url: str)
      return
    }

    if str.contains("notice"){
      Routable.notice(url: str)
    }

  }

}






