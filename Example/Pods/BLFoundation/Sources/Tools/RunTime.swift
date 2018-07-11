//
//  BLFoundation
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

public class RunTime {

  /// 交换方法
  ///
  /// - Parameters:
  ///   - target: 被交换的方法名
  ///   - replace: 用于交换的方法名
  ///   - classType: 所属类型
  public class func exchangeMethod(target: String,
                                   replace: String,
                                   class classType: AnyClass) {
    exchangeMethod(selector: Selector(target),
                   replace: Selector(replace),
                   class: classType)
  }
  /// 交换方法
  ///
  /// - Parameters:
  ///   - selector: 被交换的方法
  ///   - replace: 用于交换的方法
  ///   - classType: 所属类型
  public class func exchangeMethod(selector: Selector,
                                   replace: Selector,
                                   class classType: AnyClass) {
    let select1 = selector
    let select2 = replace
    let select1Method = class_getInstanceMethod(classType, select1)
    let select2Method = class_getInstanceMethod(classType, select2)
    let didAddMethod  = class_addMethod(classType,
                                        select1,
                                        method_getImplementation(select2Method!),
                                        method_getTypeEncoding(select2Method!))
    if didAddMethod {
      class_replaceMethod(classType,
                          select2,
                          method_getImplementation(select1Method!),
                          method_getTypeEncoding(select1Method!))
    }else {
      method_exchangeImplementations(select1Method!, select2Method!)
    }
  }

  /// 获取方法列表
  ///
  /// - Parameter classType: 所属类型
  /// - Returns: 方法列表
  public class func methods(from classType: AnyClass) -> [Method] {
    var methodNum: UInt32 = 0
    var list = [Method]()
    let methods = class_copyMethodList(classType, &methodNum)
    for index in 0..<numericCast(methodNum) {
      if let met = methods?[index] {
        list.append(met)
      }
    }
    free(methods)
    return list
  }

  /// 获取属性列表
  ///
  /// - Parameter classType: 所属类型
  /// - Returns: 属性列表
  public class func properties(from classType: AnyClass) -> [objc_property_t] {
    var propNum: UInt32 = 0
    let properties = class_copyPropertyList(classType, &propNum)
    var list = [objc_property_t]()
    for index in 0..<Int(propNum) {
      if let prop = properties?[index]{
        list.append(prop)
      }
    }
    free(properties)
    return list
  }

  /// 成员变量列表
  ///
  /// - Parameter classType: 类型
  /// - Returns: 成员变量
  public class func ivars(from classType: AnyClass) -> [Ivar] {
    var ivarNum: UInt32 = 0
    let ivars = class_copyIvarList(classType, &ivarNum)
    var list = [Ivar]()
    for index in 0..<numericCast(ivarNum) {
      if let ivar: objc_property_t = ivars?[index] {
        list.append(ivar)
      }
    }
    free(ivars)
    return list
  }
  
}
