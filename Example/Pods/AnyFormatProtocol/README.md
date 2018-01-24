# AnyFormatProtocol

[![CI Status](http://img.shields.io/travis/1581799848@qq.com/AnyFormatProtocol.svg?style=flat)](https://travis-ci.org/1581799848@qq.com/AnyFormatProtocol)
[![Version](https://img.shields.io/cocoapods/v/AnyFormatProtocol.svg?style=flat)](http://cocoapods.org/pods/AnyFormatProtocol)
[![License](https://img.shields.io/cocoapods/l/AnyFormatProtocol.svg?style=flat)](http://cocoapods.org/pods/AnyFormatProtocol)
[![Platform](https://img.shields.io/cocoapods/p/AnyFormatProtocol.svg?style=flat)](http://cocoapods.org/pods/AnyFormatProtocol)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

```Swift
use: format<T>(Any?,deault: T) -> T 
for example:
let int = format("1",default: 6)   ==> 1
let int = format(nil,default: 6)   ==> 6
let int = format(nil)    	   ==> 0
```

## Installation

AnyFormatProtocol is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AnyFormatProtocol"
```

## Author

linger: linhan.bigl055@outlook.com

## License

AnyFormatProtocol is available under the Apache License 2.0 license. See the LICENSE file for more info.
