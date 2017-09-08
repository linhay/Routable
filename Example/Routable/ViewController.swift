//
//  ViewController.swift
//  Routable
//
//  Created by bigL055 on 06/10/2017.
//  Copyright (c) 2017 bigL055. All rights reserved.
//

import UIKit
import Routable

class ViewController: UITableViewController {

  @IBAction func event1(_ sender: UIButton) {
    guard let vc = Routable.viewController(url: "http://b/b") else { return }
    navigationController?.pushViewController(vc, animated: true)
  }

  @IBAction func event2(_ sender: UIButton) {
    guard let item = Routable.view(url: "http://c/c") else { return }
    let count = view.subviews.count
    item.frame = CGRect(x: count * 80, y: 0, width: 80, height: 80)
    sender.addSubview(item)
  }

  @IBAction func event3(_ sender: UIButton) {
  }

}

