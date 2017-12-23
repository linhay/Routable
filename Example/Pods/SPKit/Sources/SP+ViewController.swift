//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension BLExtension where Base: UIViewController {

  public var isByPresented: Bool {
    guard base.navigationController != nil else { return false }
    guard base.navigationController!.viewControllers.count > 0 else { return false }
    guard base.presentingViewController == nil else { return false }
    return true
  }

  /// 是否是当前显示控制器
  public var isVisible: Bool{
    return base.navigationController?.visibleViewController == base
  }

  public func push(vc: UIViewController?, animated: Bool) {
    guard let vc = vc else { return }
    if let vc = vc as? UINavigationController {
      vc.pushViewController(vc, animated: animated)
    }else{
      base.navigationController?.pushViewController(vc, animated: animated)
    }
  }

 @discardableResult public func pop(animated: Bool) -> UIViewController? {
    if let vc = base as? UINavigationController {
      return vc.popViewController(animated: animated)
    }else{
      return base.navigationController?.popViewController(animated: animated)
    }
  }

 @discardableResult public func pop(vc: UIViewController, animated: Bool) -> [UIViewController]? {
    if let vc = base as? UINavigationController {
      return vc.popToViewController(vc, animated: animated)
    }else{
      return base.navigationController?.popToViewController(vc, animated: animated)
    }
  }

 @discardableResult public func pop(toRootVC animated: Bool) -> [UIViewController]? {
    if let vc = base as? UINavigationController {
      return vc.popToRootViewController(animated: animated)
    }else{
      return base.navigationController?.popToRootViewController(animated: animated)
    }
  }

  public func removedSelfAfterPush() {
    guard let vcs = base.navigationController?.viewControllers else{ return }
    guard let flags = vcs.index(of: base.self) else { return }
    base.navigationController?.viewControllers.remove(at: flags)
  }
}

public extension UIStoryboard {
  /// 获取storyBoard中对应的UIViewController
  /// - Parameter type: ViewController类型
  /// - Returns: UIViewController
 public class func viewController<T: UIViewController>(with vcType: T.Type) -> T {
    let vcName = String(describing: T.self)
    guard let vc = UIStoryboard(name: vcName, bundle: nil).instantiateInitialViewController() as? T else {
      fatalError("未寻找到对应StoryBoard viewController name:\(vcName)")
    }
    return vc
  }
}
