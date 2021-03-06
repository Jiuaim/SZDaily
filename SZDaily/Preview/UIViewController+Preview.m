//
//  UIViewController+Preview.m
//  test
//
//  Created by hsz on 2020/1/13.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "UIViewController+Preview.h"
#import "SZPreviewDrawModel.h"
#import "UIView+Preview.h"
#import "SZPreviewLayer.h"

@implementation UIViewController (Preview)

- (void)sz_startPreview {
    NSArray *data = [self findSubViews:self.view arr:@[].mutableCopy];
    self.view.hiddenAllSubViews = YES;
    
    SZPreviewLayer *layer = [SZPreviewLayer layer];
    layer.frame = self.view.bounds;
    layer.drawData = data;
    [self.view.layer addSublayer:layer];
    [layer setNeedsDisplay];
}

- (void)sz_endPreview {
    [self.view.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:SZPreviewLayer.class]) {
//            [obj removeFromSuperlayer];
            obj.hidden = YES;
            *stop = YES;
        }
    }];
    self.view.hiddenAllSubViews = NO;
}

- (NSArray *)findSubViews:(UIView *)superView arr:(NSMutableArray *)dataArr {
    [superView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj convertRect:obj.bounds toView:self.view];
        if (obj.subviews.count > 0) [self findSubViews:obj arr:dataArr];
        
        if ((obj.isPreView || [obj isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) && rect.origin.y < self.view.bounds.size.height) {
            SZPreviewDrawModel *model = [[SZPreviewDrawModel alloc] initWithFrame:rect color:[UIColor orangeColor]];
            [dataArr addObject:model];
        }
    }];
    
    return dataArr;
}

@end
