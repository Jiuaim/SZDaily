//
//  SZDiedLockViewController.m
//  SZDaily_Example
//
//  Created by hsz on 2020/5/16.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZDiedLockViewController.h"

@interface SZDiedLockViewController ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@property (nonatomic, strong) dispatch_queue_t anotherQueue;

@end

/*
 需求：外部进行请求并且需要获取到内部异步生成的request；请求任务需要控制最大并发数；
 
 当semaphore数量减小到0的时候sem锁死，semaphore锁死，通一串行线程，死锁
 */

@implementation SZDiedLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.semaphore = dispatch_semaphore_create(6);
    self.concurrentQueue = dispatch_queue_create("com.sztest.uploadLogQueue", DISPATCH_QUEUE_CONCURRENT);
//    self.anotherQueue = dispatch_queue_create("com.sztest.anotherQueue", DISPATCH_QUEUE_SERIAL);// 阻塞
//    self.anotherQueue = dispatch_get_main_queue();// 阻塞
    self.anotherQueue = dispatch_queue_create("com.sztest.anotherQueue", DISPATCH_QUEUE_CONCURRENT);// 不阻塞
    
    [self createTestView];
}

- (void)createTestView {
    
    UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    redBtn.backgroundColor = [UIColor redColor];
    redBtn.frame = CGRectMake(0, 100, 100, 100);
    
    [self.view addSubview:redBtn];
    [redBtn addTarget:self action:@selector(startRequest) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *greenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    greenBtn.backgroundColor = [UIColor greenColor];
    greenBtn.frame = CGRectMake(200, 100, 100, 100);
    
    [self.view addSubview:greenBtn];
    [greenBtn addTarget:self action:@selector(checkLock) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)startRequest {
    dispatch_async(self.anotherQueue, ^{
        for (int i = 0; i < 7; i++) {
            NSString *request = [self startTask];
            NSLog(@"%@ ----- 是否获取到请求", request);
        }
    });
}

- (void)checkLock {
    dispatch_async(self.anotherQueue, ^{
        NSLog(@"查看线程是否阻塞");
    });
}

- (NSString *)startTask {
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block NSString *request = nil;
    
    dispatch_async(self.concurrentQueue, ^{
        [self lock];
        
        sleep(0.2);
        dispatch_async(self.anotherQueue, ^{
            [self unLock];
        });
        
        request = @"return request";
        dispatch_semaphore_signal(sem);
    });
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return request;
}

- (void)lock {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
}

- (void)unLock {
    dispatch_semaphore_signal(self.semaphore);
}

@end
