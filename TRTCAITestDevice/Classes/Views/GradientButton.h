//
//  GradientButton.h
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GradientButton : UIButton
@property (nonatomic, strong) NSArray *gradientColors;
@property (nonatomic, strong) UIColor *disableColor;
@property (nonatomic, assign) BOOL isDisabled; 
@end

NS_ASSUME_NONNULL_END
