# Routable

[![CI Status](http://img.shields.io/travis/bigL055/Routable.svg?style=flat)](https://travis-ci.org/bigL055/Routable)
[![Version](https://img.shields.io/cocoapods/v/Routable.svg?style=flat)](http://cocoapods.org/pods/Routable)
[![License](https://img.shields.io/cocoapods/l/Routable.svg?style=flat)](http://cocoapods.org/pods/Routable)
[![Platform](https://img.shields.io/cocoapods/p/Routable.svg?style=flat)](http://cocoapods.org/pods/Routable)



## 安装

CocoaPods: 

```ruby
pod "SPRoutable"
```

## 使用(以swift为例)

- 导入

  ```
  import SPRoutable
  ```

- 示例

  -  必须有一个目标类
     - 目标类为swift,且存在于Frameworks中,则需要在头部添加@objc(类名)

  ```swift
  @objc(Router_swift)
  class Router_swift: NSObject {
    func router_a(params:[String: Any]) -> UIViewController {
      let vc = UIViewController()
      vc.view.backgroundColor = UIColor.blue
      return vc
    }

    func router_b() -> UIView {
      let view = UIView()
      view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
      view.backgroundColor = UIColor.red
      return view
    }

    func router_c(params: [String: Any] = [:]) {
      print(params)
    }
  }
  ```

  - 可以这样使用:

  ```swift
   get viewController:
   guard let vc = Routable.viewController(url: "http://swift/a") else { return }
  	
   get view:
   guard let v = Routable.view(url: "http://swift/b") else { return }

   get object:
   guard let v: UIView = Routable.object(url: "http://swift/b") else { return }

   get function:
   Routable.executing(url: str)
  ```

- 路由配置参数配置:

  ```swift
  Routable.classPrefix = "Router_"  // defalut: "Router_"
  Routable.funcPrefix  = "router_"  // defalut: "router_"
  Routable.paramName   = "Params"   // defalut: "Params"
  Routable.scheme	     = "scheme"   // defalut: ""
  ```

## Author

linger, linhan.bigl055@outlook.com

## License

Routable is available under the MIT license. See the LICENSE file for more info.
