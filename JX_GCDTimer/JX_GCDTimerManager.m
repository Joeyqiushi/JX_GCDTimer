//
//  JX_GCDTimer.m
//  TimerComparison
//
//  Created by Joeyxu on 6/12/15.
//  Copyright (c) 2015 com.tencent. All rights reserved.
//

#import "JX_GCDTimerManager.h"

@interface JX_GCDTimerManager()
@property (nonatomic, strong) NSMutableDictionary *timerContainer;
@end

@implementation JX_GCDTimerManager

#pragma mark - Public Method

+ (JX_GCDTimerManager *)sharedInstance {
    static JX_GCDTimerManager *_gcdTimerManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        _gcdTimerManager = [[JX_GCDTimerManager alloc] init];
    });
    
    return _gcdTimerManager;
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                         fireInstantly:(BOOL)fireInstantly
                                action:(dispatch_block_t)dispatchBlock {
    if (nil == queue)
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [self.timerContainer setObject:timer forKey:timerName];
        dispatch_resume(timer);
    }
    
    if (repeats && fireInstantly) {
        dispatch_async(queue, dispatchBlock);
    }
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.01 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (!repeats) {
            [self.timerContainer removeObjectForKey:timerName];
            dispatch_source_cancel(timer);
        }
        
        dispatchBlock();
    });
}

- (void)cancelTimerWithName:(NSString *)timerName {
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}

- (BOOL)existTimer:(NSString *)timerName {
    if ([self.timerContainer objectForKey:timerName])
        return YES;
    
    return NO;
}

@end
