//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import Foundation
// MARK: - format
public extension String {
  /// format: NSNumber
  var number: NSNumber? { return NumberFormatter().number(from: self) }
  /// format: Int
  var int: Int? { return number?.intValue }
  /// format: Double
  var double: Double? { return number?.doubleValue }
  /// format: Float
  var float: Float? { return number?.floatValue }
  /// format: Bool
  var bool: Bool? {
    if let num = number { return num.boolValue }
    switch self.lowercased() {
    case "true","yes": return true
    case "false","no": return false
    default: return nil
    }
  }

  /// format: Date
  var date: Date? {
    let selfLowercased = self
      .replacingOccurrences(of: "\n", with: "")
      .replacingOccurrences(of: "\r", with: "")
      .lowercased()
    let formatter = DateFormatter()
    let modes =  ["yyyy-MM-dd HH:mm:ss Z",
                  "yyyy-MM-dd HH:mm:ss.A",
                  "yyyy-MM-dd"]
    for mode in modes {
      formatter.dateFormat = mode
      if let date = formatter.date(from: selfLowercased) {
        return date
      }
    }
    return nil
  }

  
}


// MARK: - JSON
public extension String{

  /// JSON to dictionary
  ///
  /// - Returns: dictionary
  func dictionary<K: Hashable,V: Any>() -> [K:V] {
    if let data = data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [K:V] ?? [:]
      } catch {
        print(error.localizedDescription)
      }
    }
    return [:]
  }

  /// JSON to array
  ///
  /// - Returns: array
  func array<T: Any>() -> [T] {
    if let data = data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [T] ?? []
      } catch {
        print(error.localizedDescription)
      }
    }
    return []
  }

}
