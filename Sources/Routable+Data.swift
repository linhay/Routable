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

class ClassInfo {
  var name: String = ""
  var instance: NSObject?
  lazy var methods: [String: Method] = { return getMethods() }()
  var classType: AnyClass?
  // 暂时不考虑 类函数/变量 等调用
  // lazy var classMethods: [String: Method] = [:]
  
  class func initWith(name: String) -> ClassInfo? {
    let classInfo = ClassInfo()
    if let classType = NSClassFromString(name) as? NSObject.Type {
      classInfo.name = name
      classInfo.classType = classType
      classInfo.instance = classType.init()
    }
    
    // 不在主工程中的swift类
    if let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String,
      let classType = NSClassFromString("\(namespace).\(name)") as? NSObject.Type {
      classInfo.name = name
      classInfo.classType = classType
      classInfo.instance = classType.init()
    }
    
    if name.isEmpty { return nil }
    return classInfo
  }
  
  
  func findMethods(name: String) -> Method? {
    let list = self.methods.keys.filter { (item) -> Bool in
      return item.hasPrefix(name)
      }.sorted()
    guard let key = list.first else { return nil }
    return methods[key]
  }
  
  func getMethods() -> [String: Method] {
    guard let classType = classType else { return [:] }
    var dict = [String: Method]()
    var methodNum: UInt32 = 0
    let methods = class_copyMethodList(classType, &methodNum)
    for index in (0..<numericCast(methodNum)) {
      guard let method = methods?[index] else { continue }
      var item = Method()
      item.sel = method_getName(method)
      item.name = item.sel?.description ?? ""
      
      /// 获取返回值类型
      let returnType = method_copyReturnType(method)
      item.returnType = ObjectType(char: returnType)
      free(returnType)
      
      /// 获取参数类型
      let arguments = method_getNumberOfArguments(method)
      item.paramsTypes = (0..<arguments).map { (index) -> ObjectType in
        guard let argumentType = method_copyArgumentType(method, index) else {
          return ObjectType.unknown
        }
        let type = ObjectType.init(char: argumentType)
        free(argumentType)
        return type
      }
      
      dict.updateValue(item, forKey: item.name)
    }
    free(methods)
    return dict
  }
  
}


struct Method {
  var name: String = ""
  var sel: Selector?
  var paramsTypes: [ObjectType] = []
  var params: [String: Any] = [:]
  var returnType: ObjectType = .unknown
}

struct Config {
  static let `default` = Config(scheme: "*", classPrefix: "Router_", funcPrefix: "router_",remark:"")
  var scheme: String
  var classPrefix: String
  var funcPrefix: String
  var remark: String
  
  func desc() -> [String: String] {
    return ["scheme": scheme,
            "classPrefix": classPrefix,
            "funcPrefix": funcPrefix,
            "remark": remark]
  }
}

struct URLValue {
  public var config: Config
  public var className: String
  public var funcName: String
  public var params: [String: Any]
}

enum ObjectType: String {
  case void     = "v"  //void类型   v
  case sel      = ":"  //selector  :
  case object   = "@"  //对象类型   "@"
  case block    = "@?"
  case double   = "d"  //double类型 d
  case int      = "i"  //int类型    i
  case bool     = "B"  //C++中的bool或者C99中的_Bool B
  case longlong = "q"  //long long类型 q
  case point    = "^"  //          ^
  case unknown  = ""
  
  init(char: UnsafePointer<CChar>) {
    guard let str = String(utf8String: char) else {
      self = .unknown
      return
    }
    self = ObjectType(rawValue: str) ?? .unknown
  }
  
  //  case char     =     //char      c
  //  case char*    =     //char*     *
  //  case short    =     //short     s
  //  case long     =     //long      l
  //  case float    =     //float     f
  //  case `class`  =     //class     #
  //  case array    =     //[array type]
  //  case `struct` =     //{name=type…}
  //  case union    =     //(name=type…)
  //  case bnum     =     //A bit field of num bits
  //  case unsignedChar  = //unsigned char    C
  //  case unsignedInt   = //unsigned int     I
  //  case unsignedShort = //unsigned short   S
  //  case unsignedLong  = //unsigned long    L
  //  case unsignedLongLong = //unsigned short   Q
}

