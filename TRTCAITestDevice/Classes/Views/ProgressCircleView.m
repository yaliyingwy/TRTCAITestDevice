//
//  ProgressCircleView.m
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import "ProgressCircleView.h"
#import "UIColor+Util.h"

@interface ProgressCircleView ()

@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) UILabel *progressLabel;

@end

@implementation ProgressCircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        _progress = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 重新设置路径和标签的frame
    [self setupProgressLayer];
    [self setupProgressLabel];
}


- (void)setupProgressLayer {
    // 创建一个圆形路径
    // 计算圆的中心点
   CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
   CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
   CGFloat startAngle = -M_PI_2; // 从12点钟方向开始 (-π/2)
   CGFloat endAngle = startAngle + (2 * M_PI); // 结束于12点钟方向

   // 创建一个圆形路径
   UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:radius
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:YES];
    
    float lineWidth = 0.1*self.bounds.size.width;
    
    // 创建一个shape layer作为背景圆环
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.path = circlePath.CGPath;
    backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    backgroundLayer.strokeColor = [UIColor colorWithHexString:@"#7580E5" alpha:0.3].CGColor;
    backgroundLayer.lineWidth = lineWidth;
    backgroundLayer.strokeEnd = 1.0;
    [self.layer addSublayer:backgroundLayer];
    
    // 创建一个shape layer用于显示进度
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = circlePath.CGPath;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor colorWithHexString:@"#7580E5"].CGColor;
    self.progressLayer.lineWidth = lineWidth;
    self.progressLayer.strokeEnd = 0.0;
    self.progressLayer.lineCap = kCALineCapRound; // 圆形线帽
    [self.layer addSublayer:self.progressLayer];
}

- (void)setupProgressLabel {
    self.progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor colorWithHexString:@"#3A3C53"];
    self.progressLabel.font = [UIFont systemFontOfSize:30];
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", _progress * 100];
    [self addSubview:self.progressLabel];
}

- (void)setProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        _progress = progress;
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 0.5;
        animation.fromValue = @(self.progressLayer.strokeEnd);
        animation.toValue = @(progress);
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        self.progressLayer.strokeEnd = progress;
        [self.progressLayer addAnimation:animation forKey:@"progressAnimation"];
    });
}

@end
