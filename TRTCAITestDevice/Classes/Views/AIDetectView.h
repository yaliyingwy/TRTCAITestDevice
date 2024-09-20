//
//  AIDetectView.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import <UIKit/UIKit.h>
#import "AIDetectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface AIDetectView : UIView
@property (nonatomic, weak) id<AIDetectProtocol> detectDelegate;

-(void) setupResultView;
-(void) setupGuideView;

@end

NS_ASSUME_NONNULL_END
