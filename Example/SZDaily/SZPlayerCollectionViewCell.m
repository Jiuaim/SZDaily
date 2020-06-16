//
//  SZPlayerCollectionViewCell.m
//  SZDaily_Example
//
//  Created by hsz on 2020/6/15.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZPlayerCollectionViewCell.h"
#import "Masonry.h"

@interface SZPlayerCollectionViewCell()

@property (nonatomic, strong) UIView *mediaContainView;
@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation SZPlayerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mediaContainView];
        [self.contentView addSubview:self.playBtn];
        
        [self.mediaContainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)resetCell {
    self.playBtn.hidden = NO;
}

- (void)playAction {
    NSLog(@"点击播放");
    if ([self.delegate respondsToSelector:@selector(playerCollectionViewCellPlayAction:containView:)]) {
        self.playBtn.hidden = YES;
        [self.delegate playerCollectionViewCellPlayAction:self containView:self.mediaContainView];
    }
}

- (UIView *)mediaContainView {
    if (!_mediaContainView) {
        _mediaContainView = [[UIView alloc] init];
        _mediaContainView.backgroundColor = [UIColor purpleColor];
    }
    return _mediaContainView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setTitle:@"点击播放" forState:UIControlStateNormal];
        [_playBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

+ (CGFloat)cellWidth {
    return kScreenWidth - 75;
}

+ (CGFloat)cellHeight {
    return floor([self cellWidth] * 9 / 16.0);
}

@end
