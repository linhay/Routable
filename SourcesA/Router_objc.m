//
//  Router_objc.m
//  Pods-Routable_Example
//
//  Created by BigL on 2017/9/9.
//

#import "Router_objc.h"
#import <SPRoutable/SPRoutable-umbrella.h>
@implementation Router_objc
  
  -(int)int{
    return 888;
  }
  
  -(double)double {
    return 888.888;
  }
  
-(NSString *)string{
  return @"object-string";
}
  
-(BOOL)boolValue{
  return true;
}
  
-(CGFloat)cgfloat{
  return 123456.789;
}
  
-(NSDictionary *)dictionary {
  return @{@"1":@"2", @"3":@"4", @"5":@"6"};
}
  
-(NSArray *)array{
  return @[@"松江", @"卢俊义", @"吴用", @"公孙胜"];
}
  
-(SEL) selector{
  return NSSelectorFromString(@"string");
}
  
-(UIViewController *)vc{
  UIViewController * vc = [[UIViewController alloc] init];
  return vc;
}
  
-(void)async: (NSDictionary *)params id: (NSString *)id {
  dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
  dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//    [Routable callbackWithId:id params:@{@"1":@"2", @"3":@"4", @"5":@"6"}];
  });
}
  

@end
