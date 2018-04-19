//
//  URLUnitCell.swift
//  Routable_Example
//
//  Created by linhey on 2018/4/20.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SPKit

class URLUnitCell: UITableViewCell,SPNibProtocol {
  
  var selAction = ""{
    didSet{
      urlLabel.text = "http://swift/" + selAction
    }
  }
  
  @IBOutlet weak var urlLabel: UILabel!
  
  @IBAction func swiftEvent(_ sender: UIButton) {
    let url = "http://swift/" + selAction
    guard let value = Routable.object(url: url) else { return }
    alert(message: String(describing: value))
  }
  
  func alert(message: String) {
    let alert = UIAlertController(title: "返回值",
                                  message: message,
                                  preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction.init(title: "done", style: .cancel, handler: nil))
    sp.viewController?.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func ocEvent(_ sender: UIButton) {
    let url = "http://objc/" + selAction
    guard let value = Routable.object(url: url) else { return }
    alert(message: String(describing: value))
  }
  
}
