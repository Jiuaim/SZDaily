//
//  SZImageCacheViewController.m
//  SZDaily_Example
//
//  Created by hsz on 2020/7/1.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZImageCacheViewController.h"
#import <SZCategory.h>
#import "UIImageView+WebCache.h"
#import <SDWebImage.h>

/*
 1.imageWithContentsOfFile取图后当图片销毁不占用内存，imageNamed会占用内存
 2.阿里云请求图片后面链接拼宽高后会降低图片大小(宽高，size)，传值不能超过4096*4096
 3.阿里云会根据宽高传值和图片比例自动缩放
 */

/*
 NSUInteger s1 = UIImagePNGRepresentation(thumbImage).length;
 NSUInteger s2 = UIImageJPEGRepresentation(thumbImage, 1).length;
 NSUInteger s3 = CGImageGetHeight(thumbImage.CGImage) * CGImageGetBytesPerRow(thumbImage.CGImage);
 NSLog(@"s1:%u",s1); // s1 is the size of a .png image when saved to a file
 NSLog(@"s2:%u",s2); // s2 is the size of a .jpg image when save to a file with best quality
 NSLog(@"s3:%u",s3); // correct
 
 // Why image size different in memory and disk?
 Size in memory is based on the size (width and height) and depth (bytes per pixel) of the photo. In-memory photos are not compressed as jpeg or png photos are on disk.
 */

/*
 1.阿里云请求图片拼接宽高，降低请求图片宽高和大小
    1)根据固定宽或者高 * scale传值(自动比例返回)
    2)如果宽*高*scale大于4096*4096，不再传值
    3)依旧使用SDWebImage的自动解析功能，不过大图在销毁页面或者内存告警时，清除图片缓存(UIImageView强引用图片缓存)
 2.设置缓存图片数量上限/缓存大小上限
 3.SDImageCacheConfig.shouldCacheImagesInMemory = NO;不再缓存大图
 4.二三级页面返回清除图片缓存
 */

// 5669 × 1174
#define kBigImageLink @"https://xiamoon.oss-cn-hangzhou.aliyuncs.com/4444.png"

@interface SZImageCacheViewController ()

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;

@end

@implementation SZImageCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self localTest];
}

- (void)addTestBtn {
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, 50, 50)];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 50, 50)];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    btn1.backgroundColor = [UIColor redColor];
    btn2.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
}

- (void)localTest {
    NSString *subwayPath = [[NSBundle mainBundle] pathForResource:@"4444" ofType:@"png"];
    UIImage *img = [[UIImage imageWithContentsOfFile:subwayPath] aspectFillScaleToSize:CGSizeMake(300, 200) scale:[UIScreen mainScreen].scale];
//    UIImage *img = [UIImage imageWithContentsOfFile:subwayPath];
    UIImageView *image = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:image];
    image.frame = CGRectMake(0, 0, 300, 200);
    self.imageView1 = image;
    
//    UIImage *img2 = [[UIImage imageNamed:@"testImage"] aspectFitScaleToSize:CGSizeMake(300, 200) scale:[UIScreen mainScreen].scale];
    UIImage *img2 = [UIImage imageNamed:@"testImage"];
    UIImageView *image2 = [[UIImageView alloc] initWithImage:nil];
    [self.view addSubview:image2];
    image2.frame = CGRectMake(0, 300, 300, 200);
    self.imageView2 = image2;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, 50, 50)];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 50, 50)];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    btn1.backgroundColor = [UIColor redColor];
    btn2.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
}

- (void)serverTest {
    SDImageCacheConfig *config = [SDImageCacheConfig defaultCacheConfig];
    config.shouldCacheImagesInMemory = NO;
    
    UIImageView *image = [[UIImageView alloc] init];
    [self.view addSubview:image];
    image.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 1174 / 5669.0);
    self.imageView1 = image;
    
    NSString *urlString = kBigImageLink;
    CGFloat scale = [UIScreen mainScreen].scale;
    int width = (self.view.frame.size.width - 40) * scale;
    int height = width * (1174 / 5669.0);
    
    NSString *aliCloud = [NSString stringWithFormat:@"?x-oss-process=image/resize,h_%i,w_%i", 100, 100];
    NSString *picUrl = [urlString stringByAppendingString:aliCloud];
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageAvoidDecodeImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"complete --- %lld --- %f --- %f", image.sd_memoryCost, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].scale);
    }];
    
    UIImageView *image2 = [[UIImageView alloc] init];
    [self.view addSubview:image2];
    image2.frame = CGRectMake(0, 300, 300, 200);
    self.imageView2 = image2;
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil options:SDWebImageAvoidDecodeImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"complete --- %lld --- %f --- %f", image.sd_memoryCost, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].scale);
    }];
}

- (void)click1 {
//    [[SDImageCache sharedImageCache] removeImageFromMemoryForKey:kBigImageLink];
    self.imageView1.image = nil;[UIImage imageNamed:@"coupon_ expire_icon"];
//    [self.imageView1 removeFromSuperview];
//    self.imageView1 = nil;
}

- (void)click2 {
    [self.imageView2 removeFromSuperview];
    self.imageView2 = nil;
}

// SD缓存中和回传显示(自动设置)的图片是同一张
- (void)testIsEqual {
    UIImage *image1 = [[SDImageCache sharedImageCache] imageFromCacheForKey:kBigImageLink];
    UIImage *image2 = self.imageView1.image;
    
    NSLog(@"%d", [image1 isEqual:image2]);
}

@end
