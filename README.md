<p align="center">
<img src="https://raw.githubusercontent.com/linhay/Routable/master/Screenshot/logo.png" alt="Routable" title="Routable"/>
</p>

[![build](https://travis-ci.org/linhay/Routable.svg?branch=master)](https://travis-ci.org/linhay/Routable)
![language](https://img.shields.io/badge/language-swift-orange.svg)
![Platform](https://img.shields.io/cocoapods/p/SPRoutable.svg?style=flat)
![Version](https://img.shields.io/cocoapods/v/SPRoutable.svg?style=flat)
![CocoaPods](https://img.shields.io/badge/CocoaPods-supported-brightgreen.svg)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)



## 迁移至[Khala](https://github.com/linhay/Khala)

1. ##### 安装[Khala](https://github.com/linhay/Khala)

   ```
   pod 'Khala'
   ```

2. ##### 添加路由规则

   ```swift
   // 路由规则
   Khala.language = .cn
   Khala.rewrite.filters.append(RewriteFilter({ (item) -> KhalaURLValue in
       var urlComponents = URLComponents(url: item.url, resolvingAgainstBaseURL: true)
       urlComponents?.host = "Router_" + (item.url.host ?? "")
       urlComponents?.path = "/router_" + item.url.lastPathComponent
       item.url = urlComponents?.url ?? item.url
       return item
   }))
   ```

3. ##### 修改路由函数

   第一个参数修改为匿名.

   from:

   ```
   @objc func router_location(params: [String:Any],closure: (_ info: [String:Any]) -> Void){
    	...
   }
   ```

   to:

   ```swift
   @objc func router_location(_ params: [String:Any],closure: @escaping KhalaClosure){
    	...
   }
   ```

4. #### 完了.

## Require

- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+

- Swift 4.x

## Install

CocoaPod

```
pod 'SPRoutable'
```

## Useage

- [API Reference](https://linhay.github.io/SPRoutable/index.html) - Lastly, please remember to read the full whenever you may need a more detailed reference.


## Author

linhay: is.linhay@outlook.com

## License

Routable is available under the MIT license. See the LICENSE file for more info.
