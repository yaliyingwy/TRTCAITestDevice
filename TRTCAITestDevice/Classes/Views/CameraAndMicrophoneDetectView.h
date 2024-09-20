//
//  CameraAndMicrophoneDetectView.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//

#import "AIDetectView.h"
#import "CameraAndMicrophoneResultView.h"
#import "CameraAndMicrophoneGuideView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CameraAndMicrophoneDetectView : AIDetectView
@property (nonatomic, strong) CameraAndMicrophoneResultView *resultView;
@property (nonatomic, strong) CameraAndMicrophoneGuideView *guideView;

@end

NS_ASSUME_NONNULL_END
