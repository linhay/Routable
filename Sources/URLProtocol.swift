//
//  URLProtocol.swift
//  AModules
//
//  Created by bigl on 2017/11/2.
//

import Foundation

public protocol URLProtocol {
  func asURL() -> URL?
  func asString() -> String
}


extension String: URLProtocol {
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

extension URL: URLProtocol {

  public func asURL() -> URL? {
    return self
  }

  public func asString() -> String {
    return absoluteString
  }
}
