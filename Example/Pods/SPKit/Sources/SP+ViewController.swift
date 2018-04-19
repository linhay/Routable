//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension BLExtension where Base: UIViewController {

  /// tabbarHeight高度
  public var tabbarHeight: CGFloat {
    return base.tabBarController?.tabBar.height ?? 0
  }

  /// 能否回退
  public var canback: Bool {
    return (base.navigationController?.viewControllers.count ?? 0) > 1
  }

}

public extension BLExtension where Base: UIViewController {

  public var isByPresented: Bool {
    guard base.navigationController != nil else { return false }
    guard base.navigationController!.viewControllers.count > 0 else { return false }
    guard base.presentingViewController == nil else { return false }
    return true
  }

  /// 是否是当前显示控制器
  public var isVisible: Bool {
    func find(rawVC: UIViewController) -> UIViewController {
      switch rawVC {
      case let nav as UINavigationController:
        guard let vc = nav.viewControllers.last else { return rawVC }
        return find(rawVC: vc)
      case let tab as UITabBarController:
        guard let vc = tab.selectedViewController else { return rawVC }
        return find(rawVC: vc)
      case let vc where vc.presentedViewController != nil:
        return find(rawVC: vc.presentedViewController!)
      default:
        return rawVC
      }
    }
    guard let rootViewController = UIApplication.shared.windows.filter({ (item) -> Bool in
      /// =.=,如果没手动设置的话...
      return item.windowLevel == 0.0 && item.isKeyWindow
    }).first?.rootViewController else {
      return false
    }
    let vc = find(rawVC: rootViewController)
    return vc == base || vc.tabBarController == base || vc.navigationController == base
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
