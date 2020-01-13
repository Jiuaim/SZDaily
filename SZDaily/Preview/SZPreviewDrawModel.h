//
//  SZPreviewDrawModel.h
//  test
//
//  Created by hsz on 2020/1/13.
//  Copyright © 2020 hsz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZPreviewDrawModel : NSObject

@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, strong, readonly) UIColor *color;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
