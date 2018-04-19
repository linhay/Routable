#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Invocation.h"
#import "MethodSignature.h"
#import "Proxy.h"

FOUNDATION_EXPORT double RoutableAssistVersionNumber;
FOUNDATION_EXPORT const unsigned char RoutableAssistVersionString[];

