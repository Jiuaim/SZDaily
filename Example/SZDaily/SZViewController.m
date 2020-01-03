//
//  SZViewController.m
//  SZDaily
//
//  Created by hsz on 01/03/2020.
//  Copyright (c) 2020 hsz. All rights reserved.
//

#import "SZViewController.h"

@interface SZViewController ()

@end

@implementation SZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addForbiddenBtn];
    [self addForbiddenView];
}

// MARK: Forbidden
- (void)addForbiddenBtn {
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(forbiddenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)forbiddenAction:(UIButton *)btn {
    NSLog(@"forbiddenAction------button");
}

- (void)addForbiddenView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor greenColor];
    view.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:view];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forbiddenTapAction)]];
}

- (void)forbiddenTapAction {
    NSLog(@"forbiddenAction------Tap");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
