//
//  CountdownManager.h
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountdownManager : NSObject
+ (instancetype)sharedManager;
- (void)startCountdownWithDuration:(NSInteger)duration updateBlock:(void (^)(NSInteger secondsLeft))update completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
