//
//  SZPreviewLayer.m
//  test
//
//  Created by hsz on 2020/1/13.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZPreviewLayer.h"
#import "SZPreviewDrawModel.h"

@implementation SZPreviewLayer

- (void)drawInContext:(CGContextRef)ctx {
    
    for (int i = 0; i < self.drawData.count; i++) {
        SZPreviewDrawModel *model = self.drawData[i];
        
        if (!model.color) continue;
        CGContextSetFillColorWithColor(ctx, model.color.CGColor);
        CGContextFillRect(ctx, model.frame);
    }
}

@end
