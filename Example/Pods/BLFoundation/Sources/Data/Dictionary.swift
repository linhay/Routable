//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import UIKit


public extension Dictionary {

  /// 根据下标集合获取元素集合
  ///
  /// - Parameter keys: 下标集合
  public subscript(keys: [Key]) -> [Value] {
    let values = keys.flatMap { (key) -> Value? in
      return self[key]
    }
    return values
  }

}

public extension Dictionary {
  /// 从字典中随机取值
  ///
  /// - Returns: 值
  public var random: Value? {
    get{
      if isEmpty { return nil }
      let index: Int = Int(arc4random_uniform(UInt32(self.count)))
      return Array(self.values)[index]
    }
  }

  /// 检查是否有值
  ///
  /// - Parameter key: key名
  /// - Returns: 是否
  public func has(key: Key) -> Bool {
    return index(forKey: key) != nil
  }

  /// 更新字典
  ///
  /// - Parameter dicts: 单个/多个字典
  /// - Returns: 新字典
  public mutating func update(dicts: Dictionary...) {
    dicts.forEach { (dict) in
      dict.forEach({ (item) in
        self.updateValue(item.value, forKey: item.key)
      })
    }
  }

  /// 格式化为Json
  ///
  /// - Returns: Json字符串
  public func formatJSON(prettify: Bool = false) -> String {
    guard JSONSerialization.isValidJSONObject(self) else {
      return "{}"
    }
    let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted: JSONSerialization.WritingOptions()
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
      return String(data: jsonData, encoding: .utf8) ?? "{}"
    } catch {
      return "{}"
    }
  }

}
