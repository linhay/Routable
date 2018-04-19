//
//  Routable+ObjectType.swift
//  AModules
//
//  Created by linhey on 2018/3/2.
//

import UIKit

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
