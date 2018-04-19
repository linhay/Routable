//
//  Routable+URL.swift
//  AModules
//
//  Created by linhey on 2018/4/19.
//

import UIKit

extension Routable {
  
  /// 格式化url
  ///
  /// - Parameters:
  ///   - url: 待格式化 url 或 url 字符串
  ///   - params: 待拼接入url得参数
  /// - Returns: 合并后的 url
  public class func createURL(url: URLCoin,params:[String: Any]) -> URL?{
    if params.isEmpty { return url.asURL() }
    guard var components = URLComponents(string: url.asString()) else { return nil }
    var querys = components.queryItems ?? []
    let newQuerys = params.map { (item) -> URLQueryItem in
      switch item.value {
      case let v as String:
        return URLQueryItem(name: item.key, value: v)
      case let v as [String:Any]:
        return URLQueryItem(name: item.key, value: RoutableHelp.formatJSON(data: v))
      case let v as [Any]:
        return URLQueryItem(name: item.key, value: RoutableHelp.formatJSON(data: v))
      default:
        return URLQueryItem(name: item.key, value: String(describing: item.value))
      }
    }
    querys += newQuerys
    components.queryItems = querys
    return components.url
  }
  
  /// 处理参数类型
  ///
  /// - Parameter string: 需要处理的参数字符
  /// - Returns: 处理后类型
  class func dealValueType(string: String?) -> Any? {
    guard var str = string?.removingPercentEncoding else { return string }
    guard !str.isEmpty else { return str }
    str = str.trimmingCharacters(in: CharacterSet.whitespaces)
    guard str.hasPrefix("[") || str.hasPrefix("{") else { return str }
    let dict = RoutableHelp.dictionary(string: str)
    if !dict.isEmpty { return dict }
    let array = RoutableHelp.array(string: str)
    if !array.isEmpty { return array }
    return str
  }
  
  /// 获取路径所需参数
  ///
  /// - Parameter url: 路径
  /// - Returns: 所需参数
  class func urlParse(url: URL) -> (class: String,function: String,params: [String: Any])?{
    
    /// 处理协议头合法
    guard (scheme.isEmpty || url.scheme == scheme),
      let function = url.path.components(separatedBy: "/").last,
      let className = url.host else { return nil }
    
    /// 处理参数
    var params = [String: Any]()
    if let urlstr = url.query {
      urlstr.components(separatedBy: "&").forEach { (item) in
        let list = item.components(separatedBy: "=")
        if list.count == 2 {
          params[list.first!] = dealValueType(string: list.last)
        }else if list.count > 2 {
          params[list.first!] = dealValueType(string: list.dropFirst().joined())
        }
      }
    }
    return (className,function,params)
  }
}
