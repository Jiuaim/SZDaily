//
//  SZPlayerTableViewCell.m
//  SZDaily_Example
//
//  Created by hsz on 2020/6/15.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZPlayerTableViewCell.h"
#import "SZPlayerCollectionViewFlowLayout.h"
#import "SZPlayerCollectionViewCell.h"
#import <AVKit/AVKit.h>
#import "Masonry.h"

@interface SZPlayerTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SZPlayerCollectionViewCellDelegate> {
    NSInteger _currentIndex;
    CGFloat _dragStartX;
    CGFloat _dragEndX;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SZPlayerCollectionViewFlowLayout *layout;

@property (nonatomic, strong) AVPlayerViewController *playerViewController;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SZPlayerTableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseMediaPlayer) name:@"mediaPageWillEndShow" object:nil];
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo([SZPlayerCollectionViewCell cellHeight]);
        }];
    }
    return self;
}

- (void)cellWillEndDisplay {
    [self.player pause];
}

- (void)parseMediaPlayer {
    [self.player pause];
}

- (void)startPlayWithContainView:(UIView *)containView {
    NSString *urlString = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    if (!urlString.length || !containView) return;
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:urlString]];
    self.playerViewController.player = self.player;
    [self.player play];
    
    if (self.playerViewController.view.superview) [self.playerViewController.view removeFromSuperview];
    [containView addSubview:self.playerViewController.view];
    [self.playerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containView);
    }];
}

- (void)fixCellToCenter {
    float dragMiniDistance = self.bounds.size.width / 20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _currentIndex -= 1;//向右
    } else if(_dragEndX -  _dragStartX >= dragMiniDistance) {
        _currentIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    _currentIndex = _currentIndex <= 0 ? 0 : _currentIndex;
    _currentIndex = _currentIndex >= maxIndex ? maxIndex : _currentIndex;
    
    if (_currentIndex >= self.dataSource.count) return;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//卡片宽度
- (CGFloat)cellWidth {
    return [SZPlayerCollectionViewCell cellWidth];
}

//卡片间隔
- (CGFloat)cellMargin {
    return 15;
}

//设置左右缩进
- (CGFloat)collectionInset {
    return 20;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SZPlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SZPlayerCollectionViewCell.class) forIndexPath:indexPath];
    cell.delegate = self;
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self parseMediaPlayer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
}

#pragma mark - SZPlayerCollectionViewCellDelegate
- (void)playerCollectionViewCellPlayAction:(SZPlayerCollectionViewCell *)currentCell
                               containView:(UIView *)containView {
    NSArray *indexpaths = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in indexpaths) {
        SZPlayerCollectionViewCell *cell = (SZPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell == currentCell) continue;
        [cell resetCell];
    }

    [self.player pause];
    self.player = nil;
    [self startPlayWithContainView:containView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:SZPlayerCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SZPlayerCollectionViewCell.class)];
    }
    return _collectionView;
}

- (SZPlayerCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[SZPlayerCollectionViewFlowLayout alloc] init];
        [_layout setItemSize:CGSizeMake([SZPlayerCollectionViewCell cellWidth], [SZPlayerCollectionViewCell cellHeight])];
        [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_layout setMinimumLineSpacing:30];
    }
    return _layout;
}

- (AVPlayerViewController *)playerViewController {
    if (!_playerViewController) {
        _playerViewController = [[AVPlayerViewController alloc] init];
    }
    return _playerViewController;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@1, @2, @3, @4, @5];
    }
    return _dataSource;
}

@end
