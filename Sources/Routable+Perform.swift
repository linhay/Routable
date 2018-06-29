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

extension Routable {
  
  
  /// 获取指定对象
  ///
  /// - Parameters:
  ///   - name: 类名
  ///   - actionName: 函数名
  ///   - params: 函数参数
  ///   - isCacheTarget: 是否缓存
  /// - Returns: 对象
  class func target(urlValue: URLValue,
                    block: (([String: Any]) -> ())?) -> Any? {
    

    guard let id = getCacheId(value: urlValue) else { return nil }
    
    // 命中缓存
    if let data = cache[id] {
      if data.isBadURL { return nil }
      blockCache[id] = block
      data.params = urlValue.params
      return getReturnValue(data: data)
    }
    
    if block != nil {
      blockCache[id] = block
    }
    
    let data = RoutableData()
    data.id = id
    data.targetName = urlValue.targetName
    data.selName = urlValue.selName
    data.params = urlValue.params
    
    guard
      let target = getClass(name: urlValue.targetName),
      let sel = getSEL(target: target, name: urlValue.selName),
      target.responds(to: sel),
      let sig = Proxy.methodSignature(target, sel: sel)
      else {
        data.isBadURL = true
        cache[data.id] = data
        return nil
    }
    
    data.target = target
    data.sel = sel
    data.returnType = ObjectType(char: sig.methodReturnType)
    cache[data.id] = data
    return getReturnValue(data: data)
  }
  
  
  /// 获取类对象
  ///
  /// - Parameter name: 类名
  /// - Returns: 类对象
  class func getClass(name: String) -> NSObject? {
    func target(name: String) -> NSObject? {
      guard let targetClass = NSClassFromString(name) as? NSObject.Type else { return nil }
      let target = targetClass.init()
      
      return target
    }
    
    /// 缓存搜索
    let cacheData = cache.first { (item) -> Bool in
      return item.key == name
      }?.value.target
    
    /// 命中缓存
    if let value = cacheData {
      return value
    }
    
    if let value = target(name: classPrefix + name) {
      return value
    }
    // 不在主工程中的swift类
    if let value = target(name: namespace + "." + classPrefix + name) {
      return value
    }
    return nil
  }
  
  /// 获取指定类指定函数
  ///
  /// - Parameters:
  ///   - target: 指定类
  ///   - name: 指定函数名
  /// - Returns: 指定函数
  class func getSEL(target: NSObject, name: String) -> Selector? {
    var methodNum: UInt32 = 0
    let methods = class_copyMethodList(type(of: target), &methodNum)
    let list = (0..<numericCast(methodNum)).flatMap { (index) -> Selector? in
      guard let method = methods?[index] else { return nil }
      let sel: Selector = method_getName(method)
      guard sel.description.hasPrefix(funcPrefix + name) else { return nil }
      return sel
      }.sorted { (func1, func2) -> Bool in
        let funcName1 = func1.description
          .components(separatedBy: ":").first?
          .components(separatedBy: "With" + paramName).first ?? ""
        let funcName2 = func2.description
          .components(separatedBy: ":").first?
          .components(separatedBy: "With" + paramName).first ?? ""
        return funcName1.count < funcName2.count
    }
    free(methods)
    return list.first
  }
  
  
  
  /// 获取返回值
  ///
  /// - Parameter data: 数据
  /// - Returns: 返回值
  class func getReturnValue(data: RoutableData) -> Any? {
    switch data.returnType {
    case .object,.void:
      return getReturnObjectValue(data: data)
    default:
      return getReturnUnObjectValue(data: data)
    }

  }
  
  /// 获取 object 类型返回值
  ///
  /// - Parameter data: 数据
  /// - Returns: 返回值
  class func getReturnObjectValue(data: RoutableData) -> Any? {
    guard
      let sel = data.sel,
      let target = data.target,
      let sig = Proxy.methodSignature(target, sel: sel)
      else {
        return nil
    }
    
    var value:  Unmanaged<AnyObject>? = nil
    switch sig.numberOfArguments {
    case 2: value = target.perform(sel)
    case 3: value = target.perform(sel, with: data.params)
    case 4: value = target.perform(sel, with: data.params, with: data.id)
    default: break
    }
    if data.returnType == .void { return nil }
    return value?.takeUnretainedValue()

  }
  
  /// 获取 非object 类型返回值
  ///
  /// - Parameter data: 数据
  /// - Returns: 返回值
  class func getReturnUnObjectValue(data: RoutableData) -> Any? {
    
    guard
      let sel = data.sel,
      let target = data.target,
      let sig = Proxy.methodSignature(target, sel: sel),
      let inv = Invocation(methodSignature: sig)
      else {
        return nil
    }
    
    inv.target = target
    inv.selector = sel
    invSetParams(inv: inv, params: data.params, id: data.id)
    inv.invoke()

    switch data.returnType {
    case .longlong,.point,.int:
      var value: Int = 0
      inv.getReturnValue(&value)
      return value
    case .double:
      var value: Double = 0.0
      inv.getReturnValue(&value)
      return value
    case .bool:
      var value: Bool?
      inv.getReturnValue(&value)
      return value
    case .void:
      return nil
    case .sel:
      var value: Selector?
      inv.getReturnValue(&value)
      return value
    default:
      return nil
    }
  }
  
  
  // 参数设置
  class func invSetParams(inv: Invocation,params: [String: Any],id: String) {
    (0..<inv.methodSignature.numberOfArguments).map { (index) -> ObjectType in
      return ObjectType(char: inv.methodSignature.getArgumentType(at: index))
      }
      .dropFirst(2)
      .enumerated()
      .forEach { (element) in
        switch element.offset {
        case 1:
          var item = id
          inv.setArgument(&item, at: element.offset + 2)
        case 0:
          var item = params
          inv.setArgument(&item, at: element.offset + 2)
        default: break
        }
    }
  }
  
}
