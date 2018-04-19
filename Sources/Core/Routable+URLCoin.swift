//
//  URLProtocol.swift
//  AModules
//
//  Created by bigl on 2017/11/2.
//

import Foundation

public protocol URLCoin {
  func asURL() -> URL?
  func asString() -> String
}


extension String: URLCoin {
  public func asURL() -> URL? {
    guard let url = URL(string: self) else {
      assert(false, "检查 url: " + self)
      return nil
    }
    return url
  }

  public func asString() -> String {
    return self
  }
}

extension URL: URLCoin {

  public func asURL() -> URL? {
    return self
  }

  public func asString() -> String {
    return absoluteString
  }
}
