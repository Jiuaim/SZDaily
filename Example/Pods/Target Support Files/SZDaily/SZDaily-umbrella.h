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

#import "SZForbidden.h"
#import "NSObject+forbidden.h"
#import "UIControl+forbidden.h"
#import "UIGestureRecognizer+forbidden.h"
#import "SZShortMacro.h"

FOUNDATION_EXPORT double SZDailyVersionNumber;
FOUNDATION_EXPORT const unsigned char SZDailyVersionString[];

