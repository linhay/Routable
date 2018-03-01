//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import Foundation

public enum RegexPattern {
  case none
  case ipv4
  case illegal
  case url
  case phone
  case email
  case number(equal: Int)
  case numbers(low: Int,upper: Int)
  case isPositiveInteger
  case double(prefix: Int,suffix: Int)
  case custom(str: String)
}

public extension RegexPattern{
  var pattern: String{
    switch self {
    case .none: return ""
    case .ipv4: return "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    case .illegal:
      return "[\\\\'\"//\\[\\]{}<>＜＞「」：；、•^\\n\\s*\r]"
    case .url:
      return "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"
    case .phone:
      return "^1[3456789]\\d{9}$"
    case .email:
      return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    case .number(equal: let digit):
      return "^\\d{\(digit)}$"
    case .numbers(let low, let upper):
      return "^\\d{\(low),\(upper)}$"
    case .isPositiveInteger:
      return "^\\d+$"
    case .double(let prefix, let suffix):
     return "^\\d{0,\(prefix)}$|^(\\d{0,\(prefix)}[.][0-9]{0,\(suffix)})$"
    case .custom(let str):
      return str
    }
  }

  static func ==(lsh: RegexPattern,rsh: RegexPattern) -> Bool {
    return lsh.pattern == rsh.pattern
  }
}

public func ==(lsh: [RegexPattern],rsh: [RegexPattern]) -> Bool {
  let l = lsh.map({ (item) -> String in return item.pattern })
  let r = rsh.map({ (item) -> String in return item.pattern })
  return l == r
}


/*
 正则匹配库
 */
public struct Regex {

  let regex: NSRegularExpression
  public let pattern: String

  public init(_ pattern: String,ignoreCase: Bool = true) {
    self.pattern = pattern
    do {
      try regex = NSRegularExpression(pattern: pattern,
                                      options: ignoreCase ? .caseInsensitive: [])
    } catch  {
      regex = NSRegularExpression()
      print(error.localizedDescription)
    }
  }

  public init(_ regexPattern: RegexPattern,ignoreCase: Bool = true) {
    self.pattern = regexPattern.pattern
    do {
      try regex = NSRegularExpression(pattern: regexPattern.pattern,
                                      options: ignoreCase ? .caseInsensitive: [])
    } catch {
      regex = NSRegularExpression()
      print(error.localizedDescription)
    }
  }

  /// 替换匹配文本
  ///
  /// - Parameters:
  ///   - pattern: 匹配规则
  ///   - input: 输入字符串
  ///   - with: 替换文本
  /// - Returns: 替换后文本
  public func replace(input: String, with: String) -> String{
    let strList = stringList(input: input)
    var output = input
    strList.forEach { (item) in
      output = output.replacingOccurrences(of: item, with: with)
    }
    return output
  }

  /// 匹配
  ///
  /// - Parameters:
  ///   - input: 输入文本
  /// - Returns: 匹配结果
  public func matches(input: String) -> [NSTextCheckingResult] {
    return regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
  }

  func stringList( input: String) -> [String] {
    let res = matches(input: input)
    if res.isEmpty { return [String]() }
    var strList = [String]()
    res.forEach { (result) in
      let str = (input as NSString).substring(with: result.range)
      strList.append(str)
    }
    return strList
  }

  /// 返回一个字典  key: 匹配到的字串, Value: 匹配到的字串的Range数组
  ///
  /// - Parameters:
  ///   - input: 输入字符串
  /// - Returns: 返回一个字典  key: 匹配到的字串, Value: 匹配到的字串的Range数组
  public func stringWithRanges(input: String) -> [String: [NSRange]] {
    let res = matches(input: input)
    if res.isEmpty { return [String: [NSRange]]() }
    var dict = [String: [NSRange]]()
    res.forEach { (result) in
      let key = (input as NSString).substring(with: result.range)
      if dict[key] == nil { dict[key] = [NSRange]() }
      dict[key]?.append(result.range)
    }
    return dict
  }

  /// 匹配到的字串的Range数组
  ///
  /// - Parameters:
  ///   - input: 输入字符串
  /// - Returns: Range数组
  public func ranges(input: String) -> [NSRange] {
    let res = matches(input: input)
    if res.isEmpty { return [NSRange]() }
    var ranges = [NSRange]()
    res.forEach { (result) in ranges.append(result.range) }
    return ranges
  }
}
