//
//  CameraAndMicrophoneGuideView.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//

#import "AIGuideView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CameraAndMicrophoneGuideView : AIGuideView
@property (nonatomic, copy) void (^nextHandler)(void);

- (void) detectDone;
-(void) play;
- (void)startCountdown;
@end

NS_ASSUME_NONNULL_END
