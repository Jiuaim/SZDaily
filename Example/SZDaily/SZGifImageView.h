//
//  SZGifImageView.h
//  SZDaily_Example
//
//  Created by hsz on 2020/9/29.
//  Copyright © 2020 hsz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZGifImageView : UIImageView

@property (nonatomic, copy) void (^WebGifImageDownloadFinish)(BOOL success);
- (void)startDownloadIMGWithURLPath:(NSString *)path;
- (void)pause;
- (void)resume;

@end

NS_ASSUME_NONNULL_END
