//
//  JX_GCDTimer.h
//  TimerComparison
//
//  Created by Joeyxu on 6/12/15.
//  Copyright (c) 2015 com.tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JX_GCDTimerManager : NSObject

/**
 启动一个timer，默认精度为0.1秒
 
 @param timerName  timer的名称，作为唯一标识
 @param interval   执行的时间间隔
 @param queue      timer将被放入的队列，也就是最终action执行的队列。传入nil将自动放到一个子线程队列中
 @param repeats    timer是否循环调用
 @param action     时间间隔到点时执行的block
 */
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action;

/**
 撤销某个timer
 
 @param timerName timer的名称，作为唯一标识
 */
- (void)cancelTimerWithName:(NSString *)timerName;

/**
 撤销所有的timer
 */
- (void)cancelAllTimer;

@end
