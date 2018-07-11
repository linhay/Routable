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

public typealias RoutableBlock = @convention(block) (_ dict:[String:Any]) -> Void

public class Routable: NSObject {
  
  /* 指定 scheme 下匹配规则
   classPrefix 类名前缀
   funcPrefix  方法名前缀
   paramName   参数名
   
   适用场景: 多模块时可使用不同匹配规则
   
   🌰:
   rule: ["*": ["classPrefix": "Router_","funcPrefix": "router_","paramName":"Params"],
   "sp": ["classPrefix": "SP_","funcPrefix": "sp_","paramName":"value"]]
   
   url1: sp://device/id只会查找以下函数
   @objc(SP_device)
   class SP_device: NSObject {
   @objc func sp_id() {}
   }
   
   url1: router://device/id只会查找以下函数
   @objc(Router_device)
   class SP_device: NSObject {
   @objc func router_id() {}
   }
   */
  public static var configs = ["*":Config.default]
  /// 重定向策略 (可用于页面降级)
  public static var repleRules = [String: URLValue]()
  /// 命名空间
  static let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
  /// 缓存
  static var cache = [String: ClassInfo]()
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
  @objc public class func notice(url: URL,params:[String: Any] = [:]) {
    notice(str: url.absoluteString, params: params)
  }
  
  /// 通知所有已缓存类型函数
  ///
  /// - Parameter url: 函数路径
  @objc public class func notice(str: String,params:[String: Any] = [:]) {
    guard let url = createURL(url: str, params: params) else { return }
    guard var value = urlParse(url: url) else { return }
    if value.targetName != "notice" { return }
    for item in cache.values {
//      value.targetName = item.targetName
//      _ = target(urlValue: value, block: nil)
    }
  }
  
}

extension Routable {
  
  /*
   [待重定向URL: 重定向URL + 参数名替换(可选)]
   ["http://a/vc": "http://b/vc?errorPage=a&type=$style"] // host重定向
   URL:
   http://a/vc?style=0
   替换后:
   http://b/vc?errorPage=a&type=0
   ["http://a/vc": "http://web/vc?url=https://www.baidu.com"] //页面降级
   */
  
  /// 设置重定向规则组
  /// 
  /// - Parameter rules: 重定向规则
  @objc public class func rewrite(rules: [String: String]) {
    repleRules.removeAll()
    rules.forEach { (item) in
      if let lhsURL = URL(string: item.key),
        let rhsURL = URL(string: item.value),
        let lhsValue = urlParse(url: lhsURL),
        let cacheId = getCacheId(value: lhsValue),
        let rhsValue = urlParse(url: rhsURL) {
        repleRules[cacheId] = rhsValue
      }
    }
  }
  
  /// 解析Any类型(回调形式)
  ///
  /// - Parameters:
  ///   - url: url
  ///   - params: url 参数(选填)
  ///   - call: 回调数据
  @discardableResult @objc public class func object(str: String, params:[String: Any] = [:], call: RoutableBlock? = nil) -> Any? {
    guard let url = createURL(url: str, params: params) else { return nil }
    guard let value = urlParse(url: url) else { return nil }
    let rewriteValue = rewrite(value: value)
    return target(urlValue: rewriteValue, block: call)
  }
  
  /// 解析Any类型(回调形式)
  ///
  /// - Parameters:
  ///   - url: url
  ///   - params: url 参数(选填)
  ///   - call: 回调数据
  @discardableResult @objc public class func object(url: URL, params:[String: Any] = [:], call: RoutableBlock? = nil) -> Any? {
    return object(str: url.absoluteString, params: params, call: call)
  }
  
}

extension Routable {
  
  class func getCacheId(value: Routable.URLValue) -> String? {
    let id = value.targetName + "#" + value.selName
    if id.first == "#" || id.last == "#" { return nil }
    return id
  }
  
  /// 清除指定缓存
  ///
  /// - Parameter name: key
  public class func cacheAll() {
    cache.removeAll()
  }
}
