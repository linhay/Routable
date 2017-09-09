//
//  ViewController.swift
//  Routable
//
//  Created by bigL055 on 06/10/2017.
//  Copyright (c) 2017 bigL055. All rights reserved.
//

import UIKit
import SPRoutable

class ViewController: UITableViewController {
  let list = ["http://objc/a",
              "http://swift/a",
              "http://swift/b",
              "http://swift/b",
              "http://swift/c&ut=3"]

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
    switch indexPath.item {
    case 0:
      guard let vc = Routable.viewController(url: str) else { return }
      navigationController?.pushViewController(vc, animated: true)
    case 1:
      guard let vc = Routable.viewController(url: str) else { return }
      navigationController?.pushViewController(vc, animated: true)
    case 2:
      guard let v = Routable.view(url: str) else { return }
      tableView.addSubview(v)
    case 3:
      guard let v: UIView = Routable.object(url: str) else { return }
      tableView.addSubview(v)
    case 4:
      Routable.executing(url: str)
    default:
      return
    }
  }

}






