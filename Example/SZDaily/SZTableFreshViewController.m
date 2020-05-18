//
//  SZTableFreshViewController.m
//  SZDaily_Example
//
//  Created by hsz on 2020/5/18.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZTableFreshViewController.h"

@interface SZTableFreshViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SZTableFreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认5个元素
    [self initData];
    
    [self.view addSubview:self.tableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeDataSourceImmediatelyAfterReloadData];
    });
}

- (void)initData {
    for (int i = 0; i < 5; i++) {
        [self changeDataSource:YES];
    }
    [self.tableView reloadData];
}

- (void)changeDataSource:(BOOL)isAdd {
    if (isAdd) {
        [self.dataArr addObject:@"tableView Test"];
    } else {
        [self.dataArr removeLastObject];
    }
}

// reloadData后立马更新数据源(在reloadData后异步更新了数据)
- (void)changeDataSourceImmediatelyAfterReloadData {
    
//    [self.tableView reloadData];
    
    // 1.layoutIfNeeded
//    [self.tableView layoutIfNeeded];
    
    // 2.reloadData in next Runloop
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self changeDataSource:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(1);
            [self.tableView reloadData];
        });
    });
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"datasource - numberOfSectionsInTableView  -----  %@", [NSThread currentThread]);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"datasource - numberOfRowsInSection  -----  %@ --- %ld", [NSThread currentThread], self.dataArr.count);
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"datasource - cellForRowAtIndexPath  -----  %@", [NSThread currentThread]);
    NSNumber *dic = self.dataArr[indexPath.row];
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.backgroundColor = [UIColor redColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", dic];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"datasource - titleForHeaderInSection  -----  %@", [NSThread currentThread]);
    return @"A test";
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFotterInSection:(NSInteger)section {
    NSLog(@"datasource - titleForFotterInSection  -----  %@", [NSThread currentThread]);
    return @"A test";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"datasource - canEditRowAtIndexPath  -----  %@", [NSThread currentThread]);
    return YES;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"delegate - heightForRowAtIndexPath  -----  %@", [NSThread currentThread]);
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSLog(@"delegate - heightForFooterInSection  -----  %@", [NSThread currentThread]);
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSLog(@"delegate - viewForFooterInSection  -----  %@", [NSThread currentThread]);
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor orangeColor];
    return view;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

@end
