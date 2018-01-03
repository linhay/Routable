# Routable

[![CI Status](http://img.shields.io/travis/bigL055/Routable.svg?style=flat)](https://travis-ci.org/bigL055/Routable)
[![Version](https://img.shields.io/cocoapods/v/Routable.svg?style=flat)](http://cocoapods.org/pods/Routable)
[![License](https://img.shields.io/cocoapods/l/Routable.svg?style=flat)](http://cocoapods.org/pods/Routable)
[![Platform](https://img.shields.io/cocoapods/p/Routable.svg?style=flat)](http://cocoapods.org/pods/Routable)

## Example

![routable_swift](./ReadmeData/routable_swift.gif)
![routable_swift](./ReadmeData/routable_objc.gif)

## 简介

Routable是采用swift编写的 Target-Action形式的路由框架.参考自:[casa: iOS应用架构谈 组件化方案](https://casatwy.com/iOS-Modulization.html)

## 使用

- 使用CocoaPods安装

  ```
  pod "SPRoutable"
  ```

- 导入

  - swift

    ```swift
    import SPRoutable
    ```

  - objc

    ```objective-c
    #import<SPRoutable/Routable.h>
    ```

- 示例
  -  建立目标类用于接受Routable调用

     - 目标类为swift,且存在于Frameworks中,则需要在头部添加@objc(类名)


     - 目标类只会init一次,除非手动清除
     - 类名与函数名具有默认前缀(可自行配置)
     - swift示例:

  ```swift
  @objc(Router_swift)
  class Router_swift: NSObject {
    var flag = true

   @objc func router_a(params:[String: Any]) -> UIViewController {
      let vc = UIViewController()
      vc.view.backgroundColor = UIColor.blue
      return vc
    }

   @objc func router_b() -> UIView {
      let view = UIView()
      view.frame = CGRect(x: 0, y: 300, width: 300, height: 300)
      view.backgroundColor = flag ? UIColor.red : UIColor.blue
      flag = !flag
      return view
    }

   @objc func router_c(params: [String: Any] = [:]) {
      let alert = UIAlertController()
      alert.title = #function
      alert.message = params.description
      let action = UIAlertAction(title: "确定",
                                 style: UIAlertActionStyle.cancel,
                                 handler: nil)
      alert.addAction(action)
      UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
	@objc func router_notice() {
    print(#function + "router_notice")
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
   Routable.executing(url: "http://swift/c")

	// 需要通知对象存活保证
   send noice:
   Routable.noice(url:"http://swift/notice")
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
