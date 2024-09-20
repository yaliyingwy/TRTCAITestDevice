//
//  NetworkGuideView.m
//  Pods
//
//  Created by ywen on 2024/9/12.
//

#import "NetworkGuideView.h"
#import "Masonry/Masonry.h"
#import "LanguageManager.h"
#import "AssetsUtil.h"
#import "GradientButton.h"
#import "CountdownManager.h"
#import "UIColor+Util.h"

@interface NetworkGuideView()

@property (nonatomic, strong) UIView *detectingView;
@property (nonatomic, strong) UIView *poorView;
@property (nonatomic, strong) UIView *goodView;
@property (nonatomic, strong) GradientButton *countdownButton;

@end

@implementation NetworkGuideView

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
        _status = Detecting; // 设置默认值为Detecting
    }
    return self;
}

-(void)setupContentView {
    [super setupContentView];
    [self configureWithImage:[AssetsUtil imageNamed:@"TigoWifi"]];
}

-(void)setupGudeView {
    self.guideView = [UIView new];
    [self addSubview:self.guideView];
    
    [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(43);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-25.5);
        make.left.equalTo(self.aiImageView.mas_right).offset(19.5);
    }];
    
    [self setupDetectingUI];
    [self setupPoorUI];
    [self setupGoodUI];

}



- (void) setupDetectingUI {
    _detectingView = [UIView new];
    _detectingView.hidden = NO;
    [self.guideView addSubview:_detectingView];
    [_detectingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.guideView.mas_left);
        make.right.equalTo(self.guideView.mas_right);
        make.top.equalTo(self.guideView.mas_top);
        make.bottom.equalTo(self.guideView.mas_bottom);
    }];
    
    UILabel * textLabel = [UILabel new];
    NSString *text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.network.tip"];
    textLabel.attributedText = [self getAttributedString:text];
    [_detectingView addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.guideView.mas_centerX);
        make.centerY.equalTo(self.guideView.mas_centerY);
    }];
}

- (void) setupPoorUI {
    _poorView = [UIView new];
    _poorView.hidden = YES;
    [self.guideView addSubview:_poorView];
    [_poorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.guideView.mas_left);
        make.right.equalTo(self.guideView.mas_right);
        make.top.equalTo(self.guideView.mas_top);
        make.bottom.equalTo(self.guideView.mas_bottom);
    }];
    
    GradientButton *retestButton = [GradientButton new];
    retestButton.enabled = YES;
    NSString *retestText = [[LanguageManager sharedManager] localizedStringForKey:@"ai.button.retest"];
    [retestButton setTitle:retestText forState:UIControlStateNormal];
    [retestButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    [_poorView addSubview:retestButton];
    
    [retestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_poorView.mas_centerY);
        make.right.equalTo(_poorView.mas_centerX).offset(-8);
        make.width.equalTo(@126);
        make.height.equalTo(@46);
    }];
    
    GradientButton *nextButton = [GradientButton new];
    nextButton.enabled = NO;
    NSString *nextText = [[LanguageManager sharedManager] localizedStringForKey:@"ai.button.next"];
    [nextButton setTitle:nextText forState:UIControlStateDisabled];
    [nextButton setTitleColor:[UIColor colorWithHexString:@"#5D5F7B"] forState:UIControlStateDisabled];
    [nextButton addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    
    [_poorView addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_poorView.mas_centerY);
        make.left.equalTo(_poorView.mas_centerX).offset(8);
        make.width.equalTo(@126);
        make.height.equalTo(@46);
    }];
    
}

- (void) setupGoodUI {
    _goodView = [UIView new];
    _goodView.hidden = YES;
    
    [self.guideView addSubview:_goodView];
    [_goodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.guideView.mas_left);
        make.right.equalTo(self.guideView.mas_right);
        make.top.equalTo(self.guideView.mas_top);
        make.bottom.equalTo(self.guideView.mas_bottom);
    }];
    
    _countdownButton = [GradientButton new];
//    _countdownButton.tintColor = [UIColor redColor];
    NSString *text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.button.next"];
    [_countdownButton setTitle:text forState:UIControlStateNormal];
    [_countdownButton addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [_goodView addSubview:_countdownButton];
    
    [_countdownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_goodView.mas_centerX);
        make.centerY.equalTo(_goodView.mas_centerY);
        make.width.equalTo(@196);
        make.height.equalTo(@54);
    }];
//    [self startCountdown: text];
}

- (NSAttributedString *) getAttributedString:(NSString *) text {
    // 设置行高
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 16;
    paragraphStyle.maximumLineHeight = 16;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    // 设置字体颜色和大小
    UIColor *fontColor = [UIColor colorWithRed:93/255.0 green:95/255.0 blue:123/255.0 alpha:1];
    UIFont *font = [UIFont systemFontOfSize:14];
    // 创建属性字典
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSForegroundColorAttributeName: fontColor,
        NSFontAttributeName: font
    };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)setStatus:(NetworkDetectStatus)status {
    if (status == _status) {
        return;
    }
    _status = status;
    _goodView.hidden = status != Good;
    _poorView.hidden = status != Poor && status != Bad;
    _detectingView.hidden = status != Detecting;
}

- (void)startCountdown {
    NSString *text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.button.next"];
    [[CountdownManager sharedManager] startCountdownWithDuration:5 updateBlock:^(NSInteger secondsLeft) {
        [self.countdownButton setTitle:[NSString stringWithFormat:@"%@(%ld)", text, (long)secondsLeft] forState:UIControlStateNormal];
    } completion:^{
        [self goNext];  // Call the same action as button press on completion
    }];
}


- (void) goNext {
    NSLog(@"Button Pressed or Countdown Finished!");
    // Perform any action here
    // Optionally, restart the countdown or update the UI
    self.nextHandler();
}

-(void) retry {
    self.retryHandler();
}

@end
