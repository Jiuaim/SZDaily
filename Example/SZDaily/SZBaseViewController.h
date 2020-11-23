//
//  SZBaseViewController.h
//  SZDaily_Example
//
//  Created by hsz on 2020/11/23.
//  Copyright © 2020 hsz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZBaseViewController : UIViewController

/** 销毁时是否需要请求控制 */
- (BOOL)cancelRequestIfNeed;

/** 添加销毁用请求 */
- (void)appendRequestForPointArray:(id)request;

@end

NS_ASSUME_NONNULL_END
