//
//  Invocation.h
//  AModules
//
//  Created by linhey on 2018/4/17.
//

#import <Foundation/Foundation.h>
#import "MethodSignature.h"

@interface Invocation : NSInvocation
+ (NSInvocation *)invocationWithMethodSignature:(NSMethodSignature *)sig;
@end
