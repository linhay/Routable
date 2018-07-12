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

// MARK: - configs apis
@objc(Routable_Configs)
public class Routable_Configs: NSObject {
  var cache = ["*":Config.default]
  
  /// 获取配置列表
  ///
  /// - Returns: 配置列表
  @objc public func list() -> [String: [String: String]] {
    return cache.mapValues { (item) -> [String: String] in
      return item.desc()
    }
  }
  
  /// 获取配置列表
  ///
  /// - Parameter scheme: url scheme
  /// - Returns: 配置
  @objc public  func value(for scheme: String) -> [String: String]? {
    return cache[scheme]?.desc()
  }
  
  /// 添加/替换 配置
  ///
  /// - Parameters:
  ///   - scheme: url scheme
  ///   - classPrefix: 类名前缀
  ///   - funcPrefix: 函数名前缀
  ///   - paramName: 参数名
  ///   - remark: 备注
  @objc public func set(scheme: String,
                        classPrefix: String,
                        funcPrefix: String,
                        remark:String) {
    cache[scheme] = Config(scheme: scheme, classPrefix: classPrefix, funcPrefix: funcPrefix, remark: remark)
  }
  
  /// 移除多条指定配置
  ///
  /// - Parameter schemes: url scheme
  @objc public func remove(for schemes: [String]) -> [String: [String: String]] {
    var dict = [String: [String: String]]()
    schemes.forEach { (item) in
      dict[item] = cache.removeValue(forKey: item)?.desc()
    }
    return dict
  }
  
  /// 重置为默认配置
  ///
  /// - Returns: 默认配置
  @objc public func reset() -> [String: [String: String]] {
    cache = ["*": Config.default]
    return ["*": Config.default.desc()]
  }
  
}

extension Routable_Configs {
  
  func value(url: URL) -> Config? {
    guard let scheme = url.scheme else { return nil }
    if let value = cache[scheme] {
      return value
    }else if let value = cache["*"] {
      return value
    }
    return nil
  }
  
  func value(scheme: String) -> Config? {
    return cache[scheme]
  }
  
}
