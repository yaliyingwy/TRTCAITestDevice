//
//  NetworkGuideView.h
//  Pods
//
//  Created by ywen on 2024/9/12.
//

#import "AIGuideView.h"
#import "CommonDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkGuideView : AIGuideView

@property (nonatomic, assign) NetworkDetectStatus status;
@property (nonatomic, copy) void (^nextHandler)(void);
@property (nonatomic, copy) void (^retryHandler)(void);

- (void)startCountdown;

@end

NS_ASSUME_NONNULL_END
