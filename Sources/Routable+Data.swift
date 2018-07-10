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

extension Routable {
  
  class RoutableData {
    var id: String = ""
    var targetName = ""
    var selName = ""
    var target: NSObject?
    var sel: Selector?
    var params = [String: Any]()
    var returnType: ObjectType = .unknown
    var isBadURL = false
  }
  
  public struct Config {
    public static let `default` = Config(scheme: "*", classPrefix: "Router_", funcPrefix: "router_", paramName: "Params")
    public var scheme: String
    public var classPrefix: String
    public var funcPrefix: String
    public var paramName: String
    
    public func desc() -> [String: String] {
      return ["scheme": scheme,
              "classPrefix": classPrefix,
              "funcPrefix": funcPrefix,
              "paramName": paramName]
    }
  }
  
  public struct URLValue {
    public var config: Config
    public var targetName: String
    public var selName: String
    public var params: [String: Any]
  }
}
