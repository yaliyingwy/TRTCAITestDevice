//
//  CameraAndMicrophoneResultView.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/19.
//

#import "AIResultView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CameraAndMicrophoneResultView : AIResultView

@property (nonatomic, assign) NSInteger volume;

-(void) toggleVideo: (Boolean) on;
-(void) play;

@end

NS_ASSUME_NONNULL_END
