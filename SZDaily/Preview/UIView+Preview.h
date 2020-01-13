//
//  UIView+Preview.h
//  test
//
//  Created by hsz on 2020/1/10.
//  Copyright © 2020 hsz. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Preview)

@property (nonatomic, assign) BOOL isPreView;
@property (nonatomic, assign) BOOL hiddenAllSubViews;

@end

NS_ASSUME_NONNULL_END
