//
//  CountdownManager.m
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import "CountdownManager.h"

@interface CountdownManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger remainingSeconds;
@property (nonatomic, copy) void (^updateBlock)(NSInteger secondsLeft);
@property (nonatomic, copy) void (^completionBlock)(void);

@end

@implementation CountdownManager

+ (instancetype)sharedManager {
    static CountdownManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startCountdownWithDuration:(NSInteger)duration updateBlock:(void (^)(NSInteger secondsLeft))update completion:(void (^)(void))completion {
    self.remainingSeconds = duration;
    self.updateBlock = update;
    self.completionBlock = completion;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

- (void)updateCountdown {
    self.remainingSeconds--;
    if (self.updateBlock) {
        self.updateBlock(self.remainingSeconds);
    }
    
    if (self.remainingSeconds <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        if (self.completionBlock) {
            self.completionBlock();
        }
    }
}

- (void)dealloc {
    [self.timer invalidate];
}


@end
