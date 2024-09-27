//
//  StartView.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import <UIKit/UIKit.h>
#import "AIDetectView.h"
#import "LanguageGuideView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StartView : AIDetectView

@property (nonatomic, strong) LanguageGuideView *guideView;

- (void) autoSelect;

@end

NS_ASSUME_NONNULL_END
