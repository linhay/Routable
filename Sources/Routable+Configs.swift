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

// MARK: - public configs apis
extension Routable {
  
  /// 获取配置列表
  ///
  /// - Returns: 配置列表
  @objc public static func getConfigs() -> [String: [String: String]] {
    return configs.mapValues { (item) -> [String: String] in
      return item.desc()
    }
  }
  
  /// 获取配置列表
  ///
  /// - Parameter scheme: url scheme
  /// - Returns: 配置
  @objc public static func getConfig(scheme: String) -> [String: String]? {
    return configs[scheme]?.desc()
  }
  
  /// 添加/替换 配置
  ///
  /// - Parameters:
  ///   - scheme: url scheme
  ///   - classPrefix: 类名前缀
  ///   - funcPrefix: 函数名前缀
  ///   - paramName: 参数名
  ///   - remark: 备注
  @objc public static func setConfig(scheme: String,classPrefix: String,funcPrefix: String,paramName: String, remark:String) {
    configs[scheme] = Config(scheme: scheme, classPrefix: classPrefix, funcPrefix: funcPrefix, paramName: paramName,remark: remark)
  }
  
  /// 移除指定配置
  ///
  /// - Parameter scheme: url scheme
  /// - Returns: 配置
  @discardableResult @objc public static func removeConfig(scheme: String) -> [String:String] {
    guard let value = configs.removeValue(forKey: scheme) else { return [:] }
    return  value.desc()
  }
  
  /// 移除多条指定配置
  ///
  /// - Parameter schemes: url scheme
  @objc public static func removeConfigs(schemes: [String]) {
    schemes.forEach { (item) in
      configs.removeValue(forKey: item)
    }
  }
  
  /// 重置为默认配置
  @objc public static func resetConfigs() {
    configs = ["*": Config.default]
  }
  
}
