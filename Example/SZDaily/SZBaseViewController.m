//
//  SZBaseViewController.m
//  SZDaily_Example
//
//  Created by hsz on 2020/11/23.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZBaseViewController.h"

@interface SZBaseViewController ()
@property (nonatomic, strong) NSPointerArray *allRequest;
@end

@implementation SZBaseViewController

- (void)dealloc {
    
    if (![self cancelRequestIfNeed]) return;
    for (NSURLSessionTask *requestTask in _allRequest) {
        if (requestTask) [requestTask cancel];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Override
///MARK:取消请求方案
- (BOOL)cancelRequestIfNeed {
    return YES;
}

- (void)appendRequestForPointArray:(id)request {
    [self.allRequest addPointer:(__bridge void * _Nullable)(request)];
}

#pragma mark - Getter
- (NSPointerArray *)allRequest {
    if (!_allRequest) {
        _allRequest = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _allRequest;
}

@end
