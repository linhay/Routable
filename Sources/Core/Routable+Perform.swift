//
//  Routable+Pre.swift
//  AModules
//
//  Created by linhey on 2018/4/19.
//

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
    if data.returnType == .object {
      return getReturnObjectValue(data: data)
    }else{
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
    
    switch sig.numberOfArguments {
    case 2:
      let value = target.perform(sel)
      return value?.takeUnretainedValue()
    case 3:
      let value = target.perform(sel, with: data.params)
      return value?.takeUnretainedValue()
    case 4:
      let value = target.perform(sel, with: data.params, with: data.id)
      return value?.takeUnretainedValue()
    default:
      return nil
    }
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
        switch element.element {
        case .int:
          var item = id
          inv.setArgument(&item, at: element.offset + 2)
        case .object:
          var item = params
          inv.setArgument(&item, at: element.offset + 2)
        default: break
        }
    }
  }
  
}
