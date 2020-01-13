//
//  SZForbidden.h
//  ControlTest
//
//  Created by hsz on 2020/1/3.
//  Copyright © 2020 hsz. All rights reserved.
//

#ifndef SZForbidden_h
#define SZForbidden_h

#if __has_include(<SZDaily/SZForbidden.h>)
#import <SZDaily/UIControl+forbidden.h>
#import <SZDaily/NSObject+forbidden.h>
#import <SZDaily/UIGestureRecognizer+forbidden.h>
#else
#import "UIControl+forbidden.h"
#import "NSObject+forbidden.h"
#import "UIGestureRecognizer+forbidden.h"
#endif

#endif /* SZForbidden_h */
