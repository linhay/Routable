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

public extension BLExtension where Base: UIViewController {
  
  /// tabbarHeight高度
  public var tabbarHeight: CGFloat {
    return base.tabBarController?.tabBar.bounds.height ?? 0
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
  
  
  /// 前进至指定控制器
  ///
  /// - Parameters:
  ///   - vc: 指定控制器
  ///   - isRemove: 前进后是否移除当前控制器
  ///   - animated: 是否显示动画
  public func push(vc: UIViewController?,
                   isRemove: Bool = false,
                   animated: Bool = true) {
    guard let vc = vc else { return }
    switch base {
    case let nav as UINavigationController:
      nav.pushViewController(vc, animated: animated)
    default:
      base.navigationController?.pushViewController(vc, animated: animated)
      if isRemove {
        guard let vcs = base.navigationController?.viewControllers else{ return }
        guard let flags = vcs.index(of: base.self) else { return }
        base.navigationController?.viewControllers.remove(at: flags)
      }
    }
  }
  
  /// modal 指定控制器
  ///
  /// - Parameters:
  ///   - vc: 指定控制器
  ///   - animated: 是否显示动画
  ///   - completion: 完成后事件
  func present(vc: UIViewController?,
               animated: Bool = true,
               completion: (() -> Void)? = nil) {
    guard let vc = vc else { return }
    base.present(vc, animated: animated, completion: completion)
  }
  
  /// 后退一层控制器
  ///
  /// - Parameter animated: 是否显示动画
  /// - Returns: vc
  @discardableResult public func pop(animated: Bool) -> UIViewController? {
    switch base {
    case let nav as UINavigationController:
      return nav.popViewController(animated: animated)
    default:
      return base.navigationController?.popViewController(animated: animated)
    }
  }
  
  /// 后退至指定控制器
  ///
  /// - Parameters:
  ///   - vc: 指定控制器
  ///   - animated: 是否显示动画
  /// - Returns: vcs
  @discardableResult public func pop(vc: UIViewController, animated: Bool) -> [UIViewController]? {
    switch base {
    case let nav as UINavigationController:
      return nav.popToViewController(vc, animated: animated)
    default:
      return base.navigationController?.popToViewController(vc, animated: animated)
    }
  }
  
  /// 后退至根控制器
  ///
  /// - Parameter animated: 是否显示动画
  /// - Returns: vcs
  @discardableResult public func pop(toRootVC animated: Bool) -> [UIViewController]? {
    if let vc = base as? UINavigationController {
      return vc.popToRootViewController(animated: animated)
    }else{
      return base.navigationController?.popToRootViewController(animated: animated)
    }
  }
  
}
