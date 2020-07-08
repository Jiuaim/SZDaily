//
//  UIImage+SZImage.h
//  SZDaily_Example
//
//  Created by hsz on 2020/7/1.
//  Copyright © 2020 hsz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SZImage)

- (UIImage*)aspectFillScaleToSize:(CGSize)newSize scale:(int)scale;
- (UIImage*)aspectFitScaleToSize:(CGSize)newSize scale:(int)scale;

@end

NS_ASSUME_NONNULL_END
