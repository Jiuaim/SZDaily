//
//  SZPlayerCollectionViewCell.h
//  SZDaily_Example
//
//  Created by hsz on 2020/6/15.
//  Copyright © 2020 hsz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SZPlayerCollectionViewCell;
@protocol SZPlayerCollectionViewCellDelegate <NSObject>

// cell匹配是否当前播放cell，containView视频播放容器view
- (void)playerCollectionViewCellPlayAction:(SZPlayerCollectionViewCell *)cell
                               containView:(UIView *)containView;

@end

@interface SZPlayerCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<SZPlayerCollectionViewCellDelegate> delegate;

- (void)resetCell;

+ (CGFloat)cellWidth;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
