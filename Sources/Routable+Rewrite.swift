//
//  Routable+rewite.swift
//  AModules
//
//  Created by linhey on 2018/7/12.
//

import Foundation

@objc(Routable_rewrite)
public class Routable_Rewrite: NSObject {
  /// 重定向策略 (可用于页面降级)
  /// 自定义规则 第一优先级
  @objc public var block: RewriteBlock? = nil
  /// 默认规则组 第二优先级
  @objc public var cache = [[String: [String: Any]]]()
}

extension Routable_Rewrite {
  
  func rewrite(urlValue: URLValue) -> URLValue {
    /// 自定义规则
    if let dict = block?(["url": urlValue.ctx_url,"params": urlValue.ctx_body]),
      let urlStr = dict["url"] as? String,
      let url = URL(string: urlStr),
      let body = dict["params"] as? [String: Any],
      let configs = Routable.configs.value(url: url),
      let value = URLValue.initWith(config: configs, url: url, params: body) {
      return value
    }
    
    /// 默认规则组
    for item in cache {
      if let value = reload(urlValue: urlValue, match: item["match"] ?? [:], replce: item["replce"] ?? [:]) {
        return value
      }
    }
    
    return urlValue
  }
  
  func reload(urlValue: URLValue, match: [String: Any], replce: [String: Any]) -> URLValue? {
    // 规则匹配
    if let value = match["scheme"] as? String, value != urlValue.config.scheme { return nil }
    if let value = match["className"] as? String, value != urlValue.className { return nil }
    if let value = match["funcName"] as? String, value != urlValue.funcName { return nil }
    if let value = match["isHasParams"] as? [String] {
      for item in value {
        if !urlValue.params.keys.contains(item) { return nil }
      }
    }
    
    if let value = match["params"] as? [String: Any] {
      for item in value {
        if let res = urlValue.params[item.key], String(describing: res) != String(describing: item.value) { return nil }
      }
    }
    
    var urlValue = urlValue
    /// 替换
    if let scheme = replce["scheme"] as? String, let configs = Routable.configs.value(scheme: scheme) {
      urlValue.config = configs
    }
    
    if let className = replce["className"] as? String, !className.isEmpty {
      urlValue.className = className
    }
    
    if let funcName = replce["funcName"] as? String, !funcName.isEmpty {
      urlValue.funcName = funcName
    }
    
    if let params = replce["params"] as? [String: Any] {
      var lastParams = urlValue.params
      var newParams = urlValue.params
      
      if params["$.params"] as? Bool == false {
        newParams = [:]
      }
      
      for item in params {
        if let value = item.value as? String, value.hasPrefix("$.") {
          let key = value.dropFirst(2).description
          newParams[item.key] = lastParams[key]
        }else {
          newParams[item.key] = item.value
        }
      }
    }
    
    return urlValue
  }
}
