//
//  SZAutoTableHeaderHeightViewController.m
//  SZDaily_Example
//
//  Created by hsz on 2020/5/28.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZAutoTableHeaderHeightViewController.h"
#import "Masonry.h"
#import "SZCategory.h"

@interface TestView : UIView

@property (nonatomic, strong) UIView *blueView;

@end

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.blueView];
        
        [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.right.offset(-20).priorityHigh();
            make.top.offset(8);
            make.bottom.offset(-24).priorityMedium();
            make.height.mas_equalTo(self.blueView.mas_width).multipliedBy(0.4);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-20-20);
        }];
    }
    return self;
}

- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [UIView new];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;
}

@end

@interface SZAutoTableHeaderHeightViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *testHeaderView;

@end

@implementation SZAutoTableHeaderHeightViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.testHeaderView;
    [self.tableView sz_sizeHeaderToFit];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor redColor];
    
    cell.textLabel.text = @"134543453sagagdgfadfgadfgadf";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s", __func__);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (UIView *)testHeaderView {
    if (!_testHeaderView) {
        _testHeaderView = [TestView new];
    }
    return _testHeaderView;
}

@end
