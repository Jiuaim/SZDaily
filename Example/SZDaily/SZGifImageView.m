//
//  SZGifImageView.m
//  SZDaily_Example
//
//  Created by hsz on 2020/9/29.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZGifImageView.h"
#import "SDWebImageDownloader.h"
#import "NSData+ImageContentType.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

/*
 UkeWebGifImageView *gif = [[UkeWebGifImageView alloc] init];
 [self.view addSubview:gif];
 layout
 
 [gif startDownloadIMGWithURLPath:@"https://big-class.oss-cn-hangzhou.aliyuncs.com/mobile/hd/app_referral_2.gif?x-oss-process=image/resize,w_670"];
 
 1.cpu换取内存
 2.获取对应像素比gif图片
 3.采样处理图片
 */

@interface SZGifImageView ()

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSTimeInterval interval;

@end

@implementation SZGifImageView

- (void)pause {
    [self invalidateTime];
}

- (void)resume {
    [self startTimeWithInterval:self.interval];
}

- (void)startTimeWithInterval:(NSTimeInterval)interval {
    [self invalidateTime];
    self.interval = interval <= 0 ? 1 : interval;// interval * 4; 客户端采样
    if (!interval) return;
    
    __weak typeof(self)weakSelf = self;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_source_set_timer(_timer, delayTime, interval * NSEC_PER_SEC, 0.0);
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf beginUpdateUI];
    });
    dispatch_resume(_timer);
}

- (void)invalidateTime {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)beginUpdateUI {
    self.image = [self animatedGIFWithData:_data];
}

- (void)startDownloadIMGWithURLPath:(NSString *)path {
    __weak typeof(self) weak_self = self;
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:path] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        BOOL success = (image && data && finished && error == nil);
        if (weak_self.WebGifImageDownloadFinish) {
            weak_self.WebGifImageDownloadFinish(success);
        }
        
        if (!success) {
            [weak_self invalidateTime];
            return;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([NSData sd_imageFormatForImageData:data] == SDImageFormatGIF) {
                weak_self.data = data;
                CGFloat interval;
                if (image.images.count <= 1) {
                    interval = 0;
                    [weak_self beginUpdateUI];
                } else {
                    interval = image.duration / ((CGFloat)image.images.count);
                }
                weak_self.currentIndex = 0;
                [weak_self startTimeWithInterval:interval];
            } else {
                weak_self.image = image;
            }
        }];
    }];
}

- (UIImage *)animatedGIFWithData:(NSData *)data {
    if (!data) return nil;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, _currentIndex % count, NULL);
        _currentIndex+=1;// += 4;客户端采样
        animatedImage = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        CGImageRelease(image);
    }
    CFRelease(source);
    return animatedImage;
}
@end
