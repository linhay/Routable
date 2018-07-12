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
  class func target(urlValue: URLValue, block: RoutableBlock?) -> Any? {
    let className = urlValue.config.classPrefix + urlValue.className
    let funcName = urlValue.config.funcPrefix + urlValue.funcName
    if let classInfo = cache.cache[className] {
      if let method = classInfo.findMethods(name: funcName) {
        return getReturnValue(instance: classInfo, method: method,params: urlValue.params,block: block)
      }
    } else if let classInfo = ClassInfo.initWith(name: className) {
      cache.cache[className] = classInfo
      if let method = classInfo.findMethods(name: funcName) {
        return getReturnValue(instance: classInfo, method: method,params: urlValue.params,block: block)
      }
    }
    return nil
  }
  
  /// 通知已实例化类
  ///
  /// - Parameters:
  ///   - urlValue: urlValue
  ///   - block: block
  class func notice(urlValue: URLValue, block: RoutableBlock?) {
    let funcName = urlValue.config.funcPrefix + urlValue.funcName
    cache.cache.values.forEach { (classInfo) in
      if let method = classInfo.findMethods(name: funcName)  {
        _ = getReturnValue(instance: classInfo, method: method,params: urlValue.params,block: block)
      }
    }
  }
  
  /// 获取 非object 类型返回值
  ///
  /// - Parameter data: 数据
  /// - Returns: 返回值
  class func getReturnValue(instance: ClassInfo,method: Method, params: [String:Any], block: RoutableBlock?) -> Any? {
    
    guard
      let sel = method.sel,
      let target = instance.instance,
      let sig = Proxy.methodSignature(target, sel: sel)
      else {
        return nil
    }
    
    // object类型 无法通过 Invocation 获取,原因 引用计数未正确增加
    if method.returnType == .object {
      var value: Unmanaged<AnyObject>? = nil
      switch sig.numberOfArguments {
      case 2: value = target.perform(sel)
      case 3 where method.paramsTypes[2] == .block:
        value = target.perform(sel, with: block)
      case 3 where method.paramsTypes[2] == .object:
        value = target.perform(sel, with: params)
      case 4:
        if method.paramsTypes[2] == .object, method.paramsTypes[3] == .block {
          value = target.perform(sel, with: params, with: block)
        }else if method.paramsTypes[2] == .block, method.paramsTypes[3] == .object {
          value = target.perform(sel, with: block, with: params)
        }
      default: break
      }
      if method.returnType == .void { return nil }
      return value?.takeUnretainedValue()
    }
    
    guard let inv = Invocation(methodSignature: sig) else { return nil }
    inv.target = target
    inv.selector = sel
    
    if method.paramsTypes.count >= 3 {
      if method.paramsTypes[2] == .block {
        var block = block
        inv.setArgument(&block, at: 2)
      }else if method.paramsTypes[2] == .object {
        var params = params
        inv.setArgument(&params, at: 2)
      }
    }
    
    if method.paramsTypes.count >= 4 {
      if method.paramsTypes[3] == .block {
        var block = block
        inv.setArgument(&block, at: 3)
      }else if method.paramsTypes[3] == .object {
        var params = params
        inv.setArgument(&params, at: 3)
      }
    }
    
    inv.invoke()
    
    switch method.returnType {
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

}
