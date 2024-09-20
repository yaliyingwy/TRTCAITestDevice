//
//  NetworkController.h
//  Pods
//
//  Created by ywen on 2024/9/9.
//

#import <UIKit/UIKit.h>
#import "AITaskProtocol.h"
#import "AIDetectProtocol.h"
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"

NS_ASSUME_NONNULL_BEGIN



@interface AIDeviceTestController : UIViewController<TRTCCloudDelegate, AIDetectProtocol>

@property (nonatomic, weak) id<AITaskProtocol> aiTaskDelegate;
@property (nonatomic, strong) NSDictionary *trtcParams;

@end

NS_ASSUME_NONNULL_END
