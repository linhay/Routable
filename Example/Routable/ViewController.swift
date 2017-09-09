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

  @IBAction func event1(_ sender: UIButton) {
    guard let vc = Routable.viewController(url: "http://objc/a") else { return }
    navigationController?.pushViewController(vc, animated: true)
  }

  @IBAction func event2(_ sender: UIButton) {
    guard let vc = Routable.viewController(url: "http://swift/a") else { return }
    navigationController?.pushViewController(vc, animated: true)
  }

  @IBAction func event3(_ sender: UIButton) {
     Routable.executing(url: "http://swift/c?a=0")
  }

}






