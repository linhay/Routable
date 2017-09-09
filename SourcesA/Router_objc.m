//
//  Router_objc.m
//  Pods-Routable_Example
//
//  Created by BigL on 2017/9/9.
//

#import "Router_objc.h"

@implementation Router_objc

-(UIViewController *)router_a {
  UIViewController * vc = [[UIViewController alloc] init];
  vc.view.backgroundColor = UIColor.greenColor;
  return vc;
}
@end
