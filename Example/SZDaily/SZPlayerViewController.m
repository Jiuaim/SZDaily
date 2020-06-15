//
//  SZPlayerViewController.m
//  SZDaily_Example
//
//  Created by hsz on 2020/6/15.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZPlayerViewController.h"
#import "SZPlayerTableViewCell.h"
#import "Masonry.h"

@interface SZPlayerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SZPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SZPlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SZPlayerTableViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor orangeColor];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:SZPlayerTableViewCell.class forCellReuseIdentifier:NSStringFromClass(SZPlayerTableViewCell.class)];
    }
    return _tableView;
}

@end
