//
//  Router_objc.m
//  Pods-Routable_Example
//
//  Created by BigL on 2017/9/9.
//

#import "Router_objc.h"

@implementation Router_objc

-(UIViewController *)router_vc {
  UIViewController * vc = [[UIViewController alloc] init];
  vc.view.backgroundColor = UIColor.greenColor;
  return vc;
}

-(UIView *)router_view:(NSDictionary *)params {
  CGRect rect = [[UIScreen mainScreen] bounds];
  rect.size.height = 20;
  UIView * view = [[UIView alloc] init];
  view.frame = rect;
  view.backgroundColor = [UIColor darkGrayColor];
  return view;
}

-(void)router_alert:(NSDictionary *)params {
  UIAlertController * alert = [UIAlertController alertControllerWithTitle: @"router_alert"
                                                                  message: nil
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
  UIAlertAction * done = [UIAlertAction actionWithTitle: @"ok"
                                                  style: UIAlertActionStyleDestructive
                                                handler: nil];
  [alert addAction:done];
  [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];

}

-(int)router_int:(NSDictionary *)params{
  return 200;
}

-(NSInteger *)router_integer:(NSDictionary *)params{
  NSNumber * value = [[NSNumber alloc]initWithInt:300];
  return [value integerValue];
}

-(void)router_noticeResult:(NSDictionary *)params{
  NSDictionary* dict = [[NSDictionary alloc]init];
  [dict setValue:@"router_noticeResult" forKey:@"notice"];
  [self router_alert: dict];
}

@end
