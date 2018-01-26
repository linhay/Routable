//
//  Routable+String.swift
//  AModules
//
//  Created by linhey on 2018/1/24.
//

import UIKit

struct RoutableHelp {
  /// JSON to dictionary
  ///
  /// - Returns: dictionary
  static func dictionary(string: String) -> [String:Any] {
    if let data = string.data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [:]
      } catch {
        print(error.localizedDescription)
      }
    }
    return [:]
  }

  /// JSON to array
  ///
  /// - Returns: array
  static func array(string: String) -> [Any] {
    if let data = string.data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [Any] ?? []
      } catch {
        print(error.localizedDescription)
      }
    }
    return []
  }

  /// 格式化为Json
  ///
  /// - Returns: Json字符串
  static func formatJSON(data: Any) -> String {
    guard JSONSerialization.isValidJSONObject(data) else { return String(describing: data) }
    do {
      let json = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions(rawValue: 0))
      return String(data: json, encoding: .utf8) ?? String(describing: data)
    } catch {
      return String(describing: data)
    }
  }

}


