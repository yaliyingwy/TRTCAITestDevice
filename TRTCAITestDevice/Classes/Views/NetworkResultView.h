//
//  NetworkResultView.h
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import <UIKit/UIKit.h>
#import "CommonDefines.h"
#import "AIResultView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkResultView : AIResultView
@property (nonatomic, assign) NetworkDetectStatus status;

- (void)startProgressTimer;

@end

NS_ASSUME_NONNULL_END
