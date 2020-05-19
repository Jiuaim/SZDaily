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
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation SZTableFreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认5个元素
    [self initData];
    
    [self.view addSubview:self.tableView];
    
    __block BOOL stopAsyncTest = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 10; i++) {
            sleep(0.1);
            [self changeDataSourceImmediatelyAfterReloadData];
        }
        stopAsyncTest = YES;
    });
    dispatch_async(dispatch_queue_create("TableViewReloadTestQueue", DISPATCH_QUEUE_CONCURRENT), ^{
        for (int i = 0; i < 10000000; i++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeDataSource:(i % 2)];
            });
            
            // 停止线程的一种方法
            if (stopAsyncTest) {
                NSLog(@"stopAsyncTest -------");
                return;
            }
        }
    });
}

- (void)initData {
    self.semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < 5; i++) {
        [self changeDataSource:YES];
    }
    [self.tableView reloadData];
}

- (void)changeDataSource:(BOOL)isAdd {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (isAdd) {
        if (self.dataArr.count > 5000){
            dispatch_semaphore_signal(self.semaphore);
            return;
        }
        [self.dataArr addObject:@"tableView Test"];
    } else {
        [self.dataArr removeLastObject];
    }
    dispatch_semaphore_signal(self.semaphore);
}

// reloadData后立马更新数据源(在reloadData后异步更新了数据)
// 确保修改数据源一定要在主线程
/* 1.
 NSLog(@"tableView layoutIfNeeded start");
 中间包含了cellForRow方法
 NSLog(@"tableView layoutIfNeeded end");
 */

/* 2.
 NSLog(@"tableView layoutIfNeeded inner start");
 中间不会包含cellForRow方法
 NSLog(@"tableView layoutIfNeeded inner end");
 */
- (void)changeDataSourceImmediatelyAfterReloadData {
    
    // 1.layoutIfNeeded
//    NSLog(@"tableView layoutIfNeeded start");
//    [self.tableView reloadData];
//    [self.tableView layoutIfNeeded];
//    NSLog(@"tableView layoutIfNeeded end");
    
    // 2.reloadData in next Runloop
    NSLog(@"tableView layoutIfNeeded out start");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"tableView layoutIfNeeded inner start");
        [self.tableView reloadData];
        NSLog(@"tableView layoutIfNeeded inner end");
    });
    NSLog(@"tableView layoutIfNeeded out end");
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"datasource - numberOfSectionsInTableView  -----  %zd", self.dataArr.count);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"datasource - numberOfRowsInSection  -----  %zd --- %ld", self.dataArr.count, section);
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"datasource - cellForRowAtIndexPath  -----  %zd --- %ld", self.dataArr.count, indexPath.row);
    NSNumber *dic = self.dataArr[indexPath.row];
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.backgroundColor = [UIColor redColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", dic];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"datasource - titleForHeaderInSection  -----  %zd  ----  %zd", self.dataArr.count, section);
    return @"A test";
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFotterInSection:(NSInteger)section {
    NSLog(@"datasource - titleForFotterInSection  -----  %zd  ----  %zd", self.dataArr.count, section);
    return @"A test";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"datasource - canEditRowAtIndexPath  -----  %zd  ----  %zd", self.dataArr.count, indexPath.row);
    return YES;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"delegate - heightForRowAtIndexPath  -----  %zd  ----  %zd", self.dataArr.count, indexPath.row);
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSLog(@"delegate - heightForFooterInSection  -----  %zd  ----  %zd", self.dataArr.count, section);
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSLog(@"delegate - viewForFooterInSection  -----  %zd  ----  %zd", self.dataArr.count, section);
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
