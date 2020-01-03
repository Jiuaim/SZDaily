//
//  NSObject+forbidden.h
//  ControlTest
//
//  Created by hsz on 2019/11/14.
//  Copyright © 2019 hsz. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (forbidden)

@property (nonatomic, assign) NSTimeInterval sz_eventInterval;// 响应禁止事件默认1s
@property (nonatomic, assign) BOOL eventUnavailable;

@end

NS_ASSUME_NONNULL_END
