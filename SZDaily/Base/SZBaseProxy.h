//
//  SZBaseProxy.h
//  SZDaily_Example
//
//  Created by hsz on 2020/9/29.
//  Copyright © 2020 hsz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZBaseProxy : NSProxy

+ (id)allocWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
