//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import UIKit

public func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
  switch (lhs, rhs) {
  case (.some(let lhs), .some(let rhs)): return lhs == rhs
  case (.none, .none): return true
  default: return false
  }
}

public extension Array {

  /// 随机值
  public var random: Element? {
    get{
      guard count > 0 else { return nil }
      let index = Int(arc4random_uniform(UInt32(self.count)))
      return self[index]
    }
  }

  /// 打乱数组
  public var shuffled: Array {
    get{
      var result = self
      result.shuffle()
      return result
    }
  }

  /// 获取: 指定范围的数组
  ///
  /// - Parameter range: 指定范围/或者指定位置
  /// - Returns: 新数组
  public func subArray(lower: Int,upper: Int) -> Array {
    var subArr = Array()
    for index in lower...upper {
      subArr.append(self[index])
    }
    return subArr
  }

  /// 获取: 从起始位置到指定最大数量之间的数组
  ///
  /// - Parameter to: 指定数量
  /// - Returns: 子数组
  public func subArray(to: Int) -> Array {
    guard to < count else { return self }
    guard to >= 0 else { return self }
    return Array(self[0..<to])
  }

  /// 获取: 从起始位置到指定最大数量之间的数组
  ///
  /// - Parameter to: 指定数量
  /// - Returns: 子数组
  public func subArray(from: Int) -> Array {
    guard from < count else { return self }
    guard from >= 0 else { return self }
    return Array(self[from..<count])
  }

  /// 获取: 指定位置的值
  ///
  /// - Parameter index: 指定序列
  /// - Returns: 值
  public func value(at index: Int) -> Element? {
    guard index >= 0 && index < count else { return nil }
    return self[index]
  }

  /// 获取:反向序列的值
  ///
  /// - Parameter index: 序列
  /// - Returns: 指定值
  public func value(reverse index: Int) -> Int? {
    guard index >= 0 && index < count else { return nil }
    return Swift.max(self.count - index, 0)
  }

  /// 打乱数组
  public mutating func shuffle() {
    guard self.count > 1 else { return }
    var j: Int
    for i in 0..<(self.count-2) {
      j = Int(arc4random_uniform(UInt32(self.count - i)))
      if i != i+j { self.swapAt(i, i+j) }
    }
  }

  /// 分解数组:元组(第一个元素,余下的数组)
  ///
  /// - Returns: 元组(第一个元素,余下的数组)
  public func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
    return (count > 0) ? (self[0], self[1..<count]): nil
  }

  /// 格式化为Json
  ///
  /// - Returns: Json字符串
  public func formatJSON(prettify: Bool = false) -> String {
    guard JSONSerialization.isValidJSONObject(self) else {
      return "[]"
    }
    let options = prettify ? JSONSerialization.WritingOptions.prettyPrinted: JSONSerialization.WritingOptions()
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
      return String(data: jsonData, encoding: .utf8) ?? "[]"
    } catch {
      return "[]"
    }
  }
  
}


