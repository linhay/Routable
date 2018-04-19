//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension UIBarButtonItem {
  /// 快速定义一个NAV按钮
 public class func barButtonItem(buttonType: UIButtonType = .custom,
                           norImage: UIImage?,
                           highImage: UIImage?,
                           target: AnyObject?,
                           action: Selector,
                           forControlEvents: UIControlEvents = .touchUpInside)-> UIBarButtonItem {

    let leftBtn = UIButton(type: buttonType)

    //norImage - nil值判断
    var norImage = norImage
    if  norImage == nil{
      norImage = UIImage()
    }

    //norImage - nil值判断
    var highImage = highImage
    if highImage == nil {
      highImage = norImage
    }

    leftBtn.setImage(norImage, for: .normal)
    leftBtn.setImage(highImage, for: .highlighted)
    leftBtn.sizeToFit()
    leftBtn.addTarget(target, action: action, for: .touchUpInside)
    leftBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    let containView = UIView(frame: leftBtn.bounds);
    containView.addSubview(leftBtn)

    return UIBarButtonItem(customView: containView)
  }

 }
