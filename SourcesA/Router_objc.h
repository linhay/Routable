//
//  Router_objc.h
//  Pods-Routable_Example
//
//  Created by BigL on 2017/9/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Router_objc : NSObject
-(UIViewController *)router_vc;
-(UIView *)router_view;
-(void)router_alert:(NSDictionary *)params;
-(int)router_int:(NSDictionary *)params;
-(NSInteger *)router_integer:(NSDictionary *)params;
-(NSString *)router_string:(NSDictionary *)params;
-(void)router_noticeResult:(NSDictionary *)params;
@end
