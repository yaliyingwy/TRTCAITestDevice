//
//  NetworkDetectView.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//

#import <UIKit/UIKit.h>
#import "AIDetectView.h"
#import "CommonDefines.h"
#import "NetworkGuideView.h"

#import "NetworkResultView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkDetectView : AIDetectView
@property (nonatomic, assign) NetworkDetectStatus status;
@property (nonatomic, strong) NetworkGuideView *networkGuideView;
@property (nonatomic, strong) NetworkResultView *networkResultView;
@end

NS_ASSUME_NONNULL_END
