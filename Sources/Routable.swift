//
//  Router.swift
//  Router
//
//  Created by BigL on 2017/3/21.
//  Copyright © 2017年 fun.bigl.com. All rights reserved.
//

import UIKit

public class Routable {
  fileprivate let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
  public static let shared = Routable()
  fileprivate lazy var cachedTarget = [String: Any]()
}

public extension Routable {

  public func releaseCached(targetName: String) {
    let targetClassString =  "Router_" + targetName
    cachedTarget.removeValue(forKey: targetClassString)
  }

  public func performTarget(name: String,
                            actionName: String,
                            params: [String: Any] = [:],
                            isCacheTarget: Bool) -> AnyObject? {

    let targetClassString = namespace + "." + "Router_" + name
    let actionString = "router_\(actionName)WithParams:"
    var targetClass: NSObject.Type?
    var target = cachedTarget[targetClassString]

    if target == nil {
      targetClass = NSClassFromString(targetClassString) as? NSObject.Type
      target = targetClass?.init()
    }

    let action = NSSelectorFromString(actionString)

    if target == nil { return nil }

    if isCacheTarget { cachedTarget[targetClassString] = target }

    if true {
      guard let target = target as? NSObject else { return nil }
      switch target.responds(to: action) {
      case true:
        guard let object = target.perform(action, with: params) else { return nil }
        return object.takeUnretainedValue()
      case false:
        let actionString = "router_\(actionName)Params:"
        var action = NSSelectorFromString(actionString)
        switch target.responds(to: action) {
        case true:
          guard let object = target.perform(action, with: params) else { return nil }
          return object.takeUnretainedValue()
        case false:
          action = NSSelectorFromString("notFound:")
          switch target.responds(to: action) {
          case true:
            guard let object = target.perform(action, with: params) else { return nil }
            return object.takeUnretainedValue()
          case false:
            cachedTarget.removeValue(forKey: targetClassString)
            return nil
          }
        }
      }
    }
  }

  public func performAction(url: URL, completion: (([String: Any]) -> ())?) -> AnyObject? {
    var params = [String: Any]()
    var urlstr = ""

    if let query = url.query { urlstr = query.removingPercentEncoding ?? "" }
    urlstr.components(separatedBy: "&").forEach { (item) in
      let list = item.components(separatedBy: "=")
      if list.count < 2 { return }
      params[list.first!] = list.last!
    }

    let actionName = url.path.replacingOccurrences(of: "/", with: "")

    let result = performTarget(name: url.host ?? "",
                               actionName: actionName,
                               params: params,
                               isCacheTarget: false)

    completion?(["result": result ?? false])
    return result
  }
}

