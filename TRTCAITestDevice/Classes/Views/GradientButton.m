//
//  GradientButton.m
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import "GradientButton.h"
#import "UIColor+Util.h"

@implementation GradientButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gradientColors = @[
            (__bridge id)[UIColor colorWithHexString:@"#5360D8"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#717DE4"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#7C7BEF"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#A87EF3"].CGColor
        ];
        _disableColor = [UIColor colorWithHexString:@"#E0E0E8"];
        self.isDisabled = NO; // 默认不是禁用状态
    }
    return self;
}

- (void)setIsDisabled:(BOOL)isDisabled {
    _isDisabled = isDisabled;
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.isDisabled = !enabled; // 根据enabled属性设置内部状态
}



- (void)setGradientColors:(NSArray *)gradientColors {
    _gradientColors = gradientColors;
    [self setNeedsDisplay]; // 当渐变色改变时，重绘按钮
}

- (void)setDisableColor:(UIColor *)disableColor {
    _disableColor = disableColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 移除之前的渐变层（如果有）
    NSArray *sublayersCopy = [self.layer.sublayers copy];
    [sublayersCopy enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }];
    
    if (!self.isDisabled) {
        // 创建渐变层
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        
        // 设置渐变颜色
        gradientLayer.colors = self.gradientColors;
        
        // 设置渐变方向（从左到右）
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        
        // 设置圆角
        gradientLayer.cornerRadius = rect.size.height / 2;
        
        // 将渐变层插入按钮的最底层
        [self.layer insertSublayer:gradientLayer atIndex:0];
    } else {
        CALayer *disableLayer = [CALayer layer];
        disableLayer.frame = self.bounds;
        disableLayer.backgroundColor = self.disableColor.CGColor;
        disableLayer.cornerRadius = rect.size.height / 2;
        [self.layer insertSublayer:disableLayer atIndex:0];
    }
}

@end
