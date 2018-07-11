//
//  SPKit
//
//  Copyright (c) 2017 linhay - https://  github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

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
