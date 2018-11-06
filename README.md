## JX_GCDTimerManager

![](https://img.shields.io/github/license/mashape/apistatus.svg) ![](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![](https://img.shields.io/badge/iOS-8.0%2B-blue.svg)

JX_GCDTimerManager is a NSTimer like tool implemented using GCD.

## Usage

 1. Add the source files `JX_GCDTimerManager.h` and `JX_GCDTimerManager.m` to your Xcode project.
 2. Import `JX_GCDTimerManager.h` .
 3. Use in you code.

```
__weak typeof(self) weakSelf = self;
[[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"myTime_hash"
                                                       timeInterval:2.0
                                                              queue:dispatch_get_main_queue()
                                                            repeats:NO
                                                      fireInstantly:NO
                                                             action:^{
                                                                 [weakSelf doSomething];
                                                             }];
```

You can add or remove functions as you need.

## Requirements

This component requires `iOS 8.0+`.

## Notice

If you are using `JX_GCDTimerManager` as a singleton, you should watch out that timer with the same name could interfere each other, as the name is the unique key of the timer. Make sure to use unique names for timer instances.

## License

JX_GCDTimerManager is provided under the MIT license. See LICENSE file for details.
