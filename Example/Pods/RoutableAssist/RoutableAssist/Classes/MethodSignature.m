//
//  MethodSignature.m
//  Pods-RoutableAssist_Example
//
//  Created by linhey on 2018/4/17.
//

#import "MethodSignature.h"

@implementation MethodSignature

+ (nullable NSMethodSignature *)signatureWithObjCTypes:(const char *)types{
  return [NSMethodSignature signatureWithObjCTypes:types];
}

@end
