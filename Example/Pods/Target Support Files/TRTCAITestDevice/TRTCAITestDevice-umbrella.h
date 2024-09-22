#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIColor+Util.h"
#import "AIDeviceTestController.h"
#import "CommonDefines.h"
#import "AIDetectProtocol.h"
#import "AITaskProtocol.h"
#import "AISdkManager.h"
#import "AssetsUtil.h"
#import "CountdownManager.h"
#import "LanguageManager.h"
#import "AIChatCell.h"
#import "AIChatList.h"
#import "AIConversationView.h"
#import "AIDetectView.h"
#import "AIGuideView.h"
#import "AIResultView.h"
#import "AnimationView.h"
#import "CameraAndMicrophoneDetectView.h"
#import "CameraAndMicrophoneGuideView.h"
#import "CameraAndMicrophoneResultView.h"
#import "GradientButton.h"
#import "LanguageGuideView.h"
#import "LanguageSelectorView.h"
#import "NetworkDetectView.h"
#import "NetworkGuideView.h"
#import "NetworkResultView.h"
#import "ProgressCircleView.h"
#import "StartView.h"
#import "VolumeView.h"
#import "WelcomeView.h"

FOUNDATION_EXPORT double TRTCAITestDeviceVersionNumber;
FOUNDATION_EXPORT const unsigned char TRTCAITestDeviceVersionString[];

