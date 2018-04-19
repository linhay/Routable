//
//  Proxy.m
//  Pods-RoutableAssist_Example
//
//  Created by linhey on 2018/4/17.
//

#import "Proxy.h"


@implementation Proxy

+(NSMethodSignature *)methodSignature:(NSObject *)object sel:(SEL)sel {
  return [object methodSignatureForSelector:sel];
}

@end
