//
//  CharacterSet+BL.swift
//  BLFoundation
//
//  Created by bigl on 2017/11/8.
//

import Foundation

public extension CharacterSet{
 // 对urlQuery中的value转义
 public static let urlQueryValueAllowed = CharacterSet(charactersIn: "&\"#%<>[]^`{|}=").inverted

}

