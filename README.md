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

  -  you must have a target class at anywhere abount cocapods,ex:

  ```swift
  @objc(Router_swift)
  class Router_swift: NSObject {
    func router_a(params:[String: Any]) -> UIViewController {
      let vc = UIViewController()
      vc.view.backgroundColor = UIColor.blue
      return vc
    }

    func router_b() -> UIViewController {
      let vc = UIViewController()
      vc.view.backgroundColor = UIColor.red
      return vc
    }

    func router_c(params: [String: Any] = [:]) {
      print(params)
    }
  }  
  ```

  - You could use routable like:

  ```swift
   get viewController:
   guard let vc = Routable.viewController(url: "http://objc/a") else { return }
  	
   get 
  ```

    

- 路由参数配置:

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
