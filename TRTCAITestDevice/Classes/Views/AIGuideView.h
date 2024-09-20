//
//  AIGuideView.h
//  Pods
//
//  Created by ywen on 2024/9/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIGuideView : UIView

@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, strong) UIImageView *aiImageView;
@property (nonatomic, strong) UILabel *titleLabel;

-(void) setupContentView;
- (void) setupGudeView;
- (void)configureWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
