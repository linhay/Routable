//
//  Routable
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
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

import Foundation

// MARK: - cache apis
@objc(Routable_Cache)
public class Routable_Cache: NSObject {
  /// 缓存
  var cache = [String: ClassInfo]()
  
  /// 清空缓存路由类
  public func removeAll() {
    cache.removeAll()
  }
  
  /// 获取已缓存路由类名称集合
  ///
  /// - Returns: 路由类名称集合
  @objc public func keys() -> [String] {
    return cache.map({ (item) -> String in
      return item.key
    })
  }
  
  /// 从缓存中移除指定路由类
  ///
  /// - Parameter str: 路由类名称
  /// - Returns: 是否已移除该路由类
  @discardableResult @objc public func remove(str: String) -> Bool {
    guard let url = URL(string: str) else { return false }
    return remove(url: url)
  }
  
  /// 从缓存中移除指定路由类
  ///
  /// - Parameter url: 路由类名称
  /// - Returns: 是否已移除该路由类
  @discardableResult @objc public func remove(url: URL) -> Bool {
    guard let name = getClassName(url: url) else { return  false }
    cache.removeValue(forKey: name)
    return true
  }
  
  /// 重载指定路由类
  ///
  /// - Parameter str: url
  ///
  ///   1. 提前加载指定路由类 可执行该函数
  ///   2. 当你使用runtime动态向 路由类中添加函数后 建议执行该函数 重载缓存中的路由类.
  ///
  ///   As an example:
  ///
  ///   config: ["sp": ["classPrefix": "SP_","funcPrefix": "sp_"]]
  ///      url: sp://device/id
  ///
  ///   reload class:
  ///
  ///     @objc(SP_device)
  ///     class SP_device: NSObject {
  ///         @objc func sp_id() {}
  ///     }
  ///
  /// - Returns: 是否重载成功,重载失败只有3种情况:   1. url非法
  ///                                           2. 无法获取配置信息
  ///                                           3. 无法创建路由类
  @discardableResult @objc public func reload(str: String) -> Bool {
    guard let url = URL(string: str) else { return false }
    return reload(url: url)
  }
  
  /// 重载指定路由类
  ///
  /// - Parameter url: url
  ///
  ///   1. 提前加载指定路由类 可执行该函数
  ///   2. 当你使用runtime动态向 路由类中添加函数后 建议执行该函数 重载缓存中的路由类.
  ///
  ///   As an example:
  ///
  ///   config: ["sp": ["classPrefix": "SP_","funcPrefix": "sp_"]]
  ///      url: sp://device/id
  ///
  ///   reload class:
  ///
  ///     @objc(SP_device)
  ///     class SP_device: NSObject {
  ///         @objc func sp_id() {}
  ///     }
  ///
  /// - Returns: 是否重载成功,重载失败只有3种情况:   1. url非法
  ///                                           2. 无法获取配置信息
  ///                                           3. 无法创建路由类
  @discardableResult @objc public func reload(url: URL) -> Bool {
    guard let name = getClassName(url: url), let classInfo = ClassInfo.initWith(name: name) else { return false }
    cache[name] = classInfo
    return true
  }
  
}


extension Routable_Cache {
  
  fileprivate func getClassName(url: URL) -> String? {
    if let scheme = url.scheme, let host = url.host {
      if let config = Routable.configs.cache[scheme] {
        return config.classPrefix + host
        
      }else if let config = Routable.configs.cache["*"] {
        return config.classPrefix + host
      }
    }
    return nil
  }
  
}
