//
//  ViewController.m
//  JX_GCDTimer
//
//  Created by Joeyxu on 6/18/15.
//  Copyright (c) 2015 com.joeyxu. All rights reserved.
//

#import "ViewController.h"
#import "JX_GCDTimerManager.h"

@interface ViewController ()
@property (nonatomic, strong) JX_GCDTimerManager *timerManager;
@property (nonatomic, strong) NSTimer *timer;
@end

static NSString *myTimer = @"MyTimer";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 启动一个timer，每隔2秒执行一次 */
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething) object:nil];
    [thread start];
    
//    __weak typeof(self) weakSelf = self;
//    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:myTimer
//                                                           timeInterval:2.0
//                                                                  queue:nil
//                                                                repeats:NO
//                                                           actionOption:AbandonPreviousAction
//                                                                 action:^{
//                                                                     [weakSelf doSomething];
//                                                                 }];
}

/* timer每次执行打印一条log记录，在执行到n==10的时候cancel掉timer */
- (void)doSomethingEveryTwoSeconds
{
    static NSUInteger n = 0;
    NSLog(@"myTimer runs %lu times!", (unsigned long)n++);
    
    if (n >= 10) {
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:myTimer];
    }
}

- (void)doSomething
{
    _timer = [NSTimer timerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(doSomethingEveryTwoSeconds)
                                           userInfo:nil
                                            repeats:YES];
    [NSThread currentThread];
}

- (void)someWhereA
{
    _timer = [NSTimer timerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(doSomethingEveryTwoSeconds)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)someWhereB
{
    [_timer invalidate];
}

/* 持有timerManager的对象销毁时，将其中的timer全部撤销 */

- (void)dealloc
{
    [_timer invalidate];
}

@end
