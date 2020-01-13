//
//  SZPreviewDrawModel.m
//  test
//
//  Created by hsz on 2020/1/13.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZPreviewDrawModel.h"

@interface SZPreviewDrawModel ()

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIColor *color;

@end

@implementation SZPreviewDrawModel

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super init];
    if (self) {
        _frame = frame;
        _color = color;
    }
    return self;
}

@end
