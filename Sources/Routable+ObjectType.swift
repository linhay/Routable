//
//  Routable+ObjectType.swift
//  AModules
//
//  Created by linhey on 2018/3/2.
//

import UIKit

enum ObjectType: Int8 {
  case sel      = 58  //selector  :
  case object   = 64  //对象类型   "@"
  case double   = 100 //double类型 d
  case int      = 105 //int类型    i
  case longlong = 113 //long long类型 q
  case void     = 118 //void类型   v
  case point    = 94  //          ^
  case unknown  = 0
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
  //  case bool     =     //C++中的bool或者C99中的_Bool B
  //  case unsignedChar  = //unsigned char    C
  //  case unsignedInt   = //unsigned int     I
  //  case unsignedShort = //unsigned short   S
  //  case unsignedLong  = //unsigned long    L
  //  case unsignedLongLong = //unsigned short   Q
  
  init(char: CChar){
    self = ObjectType(rawValue: char) ?? .unknown
  }
}
