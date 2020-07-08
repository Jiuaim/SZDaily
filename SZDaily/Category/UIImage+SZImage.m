//
//  UIImage+SZImage.m
//  SZDaily_Example
//
//  Created by hsz on 2020/7/1.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "UIImage+SZImage.h"

@implementation UIImage (SZImage)

- (UIImage*)aspectFillScaleToSize:(CGSize)newSize scale:(int)scale {
    if (CGSizeEqualToSize(self.size, newSize)) {
        return self;
    }
    
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = MAX(aspectWidth, aspectHeight);
    
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    int finalScale = (0 == scale) ? [UIScreen mainScreen].scale : scale;
    
    if (@available(iOS 10, *)) {
        UIGraphicsImageRenderer *rederer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
        return [rederer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [self drawInRect:scaledImageRect];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, finalScale);
        [self drawInRect:scaledImageRect];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
}

- (UIImage*)aspectFitScaleToSize:(CGSize)newSize scale:(int)scale {
    if (CGSizeEqualToSize(self.size, newSize)) {
        return self;
    }
    
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = MIN(aspectWidth, aspectHeight);
    
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    int finalScale = (0 == scale) ? [UIScreen mainScreen].scale : scale;
    if (@available(iOS 10, *)) {
        UIGraphicsImageRenderer *rederer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
        return [rederer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [self drawInRect:scaledImageRect];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, finalScale);
        [self drawInRect:scaledImageRect];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
}

@end
