//
//  Router_web.swift
//  AModules
//
//  Created by linhey on 2018/5/13.
//

import UIKit
import AnyFormatProtocol

@objc(Router_web)
class Router_web: NSObject,AnyFormatProtocol {
  
  @objc func vc(params:[String:Any]) -> UIViewController? {
    
    guard let urlStr = params["url"] as? String,
      var urlCom = URLComponents(string: urlStr) else {
        return nil
    }
    
    if urlCom.queryItems == nil {
      urlCom.queryItems = []
    }
    
    params.forEach { (item) in
      if item.key != "url" {
        urlCom.queryItems?.append(URLQueryItem(name: item.key, value: format(item.value)))
      }
    }
    
    let vc = UIViewController()
    let webview = UIWebView(frame: vc.view.bounds)
    vc.view.addSubview(webview)
    let requst = URLRequest(url: urlCom.url!)
    webview.loadRequest(requst)
    return vc
  }
  
}
