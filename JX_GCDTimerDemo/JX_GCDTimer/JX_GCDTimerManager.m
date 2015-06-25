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

+ (JX_GCDTimerManager *)sharedInstance
{
    static JX_GCDTimerManager *_gcdTimerManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        _gcdTimerManager = [[JX_GCDTimerManager alloc] init];
    });
    
    return _gcdTimerManager;
}

- (NSMutableDictionary *)timerContainer
{
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)dispatchBlock
{
    if (nil == queue)
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if (0.0f == interval) {
        dispatch_async(queue, ^(void) {
            dispatchBlock();
        });
        return;
    }
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    
    /* timer精度为0.1秒 */
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatchBlock();
        
        if (!repeats) {
            [self.timerContainer removeObjectForKey:timerName];
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
}

- (void)cancelTimerWithName:(NSString *)timerName
{
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}

- (void)cancelAllTimer
{
    // Fast Enumeration
    [self.timerContainer enumerateKeysAndObjectsUsingBlock:^(NSString *timerName, dispatch_source_t timer, BOOL *stop) {
        [self.timerContainer removeObjectForKey:timerName];
        dispatch_source_cancel(timer);
    }];
}

@end
