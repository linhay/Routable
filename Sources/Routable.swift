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
import RoutableAssist

public typealias RewriteBlock  = @convention(block) (_ dict: [String: Any]) -> [String: Any]
public typealias RoutableBlock = @convention(block) (_ dict: [String: Any]) -> Void

public class Routable: NSObject {
  
  /// 指定 scheme 下匹配规则
  ///  classPrefix 类名前缀
  ///  funcPrefix  方法名前缀
  ///  paramName   参数名
  ///
  ///  适用场景: 多模块时可使用不同匹配规则
  ///
  ///  As an example:
  ///
  ///  rule: ["*": ["classPrefix": "Router_","funcPrefix": "router_"],
  ///         "sp": ["classPrefix": "SP_","funcPrefix": "sp_"]]
  ///
  ///  url1: sp://device/id只会查找以下函数:
  ///
  ///     @objc(SP_device)
  ///     class SP_device: NSObject {
  ///         @objc func sp_id() {}
  ///     }
  ///
  ///  url1: router://device/id只会查找以下函数:
  ///
  ///     @objc(Router_device)
  ///     class SP_device: NSObject {
  ///         @objc func router_id() {}
  ///     }
  
  public static let configs = Routable_Configs()
  public static let cache = Routable_Cache()
  public static let rewrite = Routable_Rewrite()
  
  @objc public class func sharedConfigs() -> Routable_Configs { return configs }
  @objc public class func sharedCache() -> Routable_Cache { return cache }
  @objc public class func sharedRewrite() -> Routable_Rewrite { return rewrite }
  
  /// 重定向策略 (可用于页面降级)
  static var repleRules = [String: URLValue]()
}

extension Routable {
  
  /// 执行路径指定函数
  ///
  /// - Parameter url: 函数路径
  @objc public class func exec(url: URL, params:[String: Any] = [:]) {
    _ = object(url: url, params: params)
  }
  
  /// 执行路径指定函数
  ///
  /// - Parameter url: 函数路径
  @objc public class func exec(str: String, params:[String: Any] = [:]) {
    _ = object(str: str, params: params)
  }
  
  /// 通知所有已缓存类型函数
  ///
  /// - Parameter url: 函数路径
  @objc public class func notice(str: String, params:[String: Any] = [:], call: RoutableBlock? = nil) {
    guard let url = URL(string: str) else { return }
    notice(url: url, params: params, call: call)
  }
  
  /// 通知所有已缓存类型函数
  ///
  /// - Parameter url: 函数路径
  @objc public class func notice(url: URL, params:[String: Any] = [:], call: RoutableBlock? = nil) {
    guard url.host == "notice", let value = urlParse(url: url, params: params) else { return }
    notice(urlValue: value, block: call)
  }
  
}

// MARK: - rewrite apis
extension Routable {
  
  /// 解析Any类型(回调形式)
  ///
  /// - Parameters:
  ///   - url: url
  ///   - params: url 参数(选填)
  ///   - call: 回调数据
  @discardableResult @objc public class func object(url: URL, params:[String: Any] = [:], call: RoutableBlock? = nil) -> Any? {
    guard let value = urlParse(url: url, params: params) else { return nil }
    let rewriteValue = rewrite.rewrite(urlValue: value)
    return target(urlValue: rewriteValue, block: call)
  }
  
  /// 解析Any类型(回调形式)
  ///
  /// - Parameters:
  ///   - str: url
  ///   - params: url 参数(选填)
  ///   - call: 回调数据
  @discardableResult @objc public class func object(str: String, params:[String: Any] = [:], call: RoutableBlock? = nil) -> Any? {
    guard let url = URL(string: str) else { return nil }
    return object(url: url, params: params, call: call)
  }
  
}

// MARK: - urlParse
extension Routable {
  
  /// 获取路径所需参数
  ///
  /// - Parameter url: 路径
  /// - Returns: 所需参数
  class func urlParse(url: URL, params: [String : Any]) -> URLValue?{
    guard let configs = self.configs.value(url: url) else { return nil }
    return URLValue.initWith(config: configs, url: url, params: params)
  }
  
}

