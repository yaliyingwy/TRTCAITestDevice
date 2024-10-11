//
//  CameraAndMicrophoneGuideView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//

#import "CameraAndMicrophoneGuideView.h"
#import "AssetsUtil.h"
#import "GradientButton.h"
#import "Masonry/Masonry.h"
#import "UIColor+Util.h"
#import "LanguageManager.h"
#import "AnimationView.h"
#import "CountdownManager.h"

@interface CameraAndMicrophoneGuideView()
@property (strong, nonatomic) UIView *sayHiView;
@property (strong, nonatomic) AnimationView *animationView;
@property (nonatomic, strong) GradientButton *doneButton;
@property (assign, nonatomic) Boolean nextClicked;

@end

@implementation CameraAndMicrophoneGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setupContentView {
    [super setupContentView];
    [self configureWithImage:[AssetsUtil imageNamed:@"TigoHi"]];
}

- (void)setupGudeView {
    _sayHiView = [UIView new];
    [self addSubview:_sayHiView];
    
    [_sayHiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(43);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-25.5);
        make.left.equalTo(self.aiImageView.mas_right).offset(19.5);
    }];
    
    UILabel *textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textColor = [UIColor colorWithHexString:@"#5D5F7B"];
    textLabel.text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.sayhi"];
    
    [_sayHiView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sayHiView.mas_top).offset(21);
        make.centerX.equalTo(_sayHiView.mas_centerX);
    }];
    _sayHiView.hidden = YES;
    
    _animationView = [AnimationView new];
    [_sayHiView addSubview:_animationView];
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_sayHiView.mas_centerX);
        make.centerY.equalTo(_sayHiView.mas_centerY);
        make.width.equalTo(@212);
        make.height.equalTo(@159);
    }];
    [_animationView configureWithJson:@"Hello" audio:@"Hello"];
    
    
    _doneButton = [GradientButton new];
    _doneButton.hidden = YES;
//    _countdownButton.tintColor = [UIColor redColor];
    NSString *text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.enter"];
    [_doneButton setTitle:text forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doneButton];
    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(42);
        make.width.equalTo(@210);
        make.height.equalTo(@54);
    }];
}

- (void)detectDone {
    _sayHiView.hidden = YES;
    _doneButton.hidden = NO;
}

- (void)play {
    _sayHiView.hidden = NO;
    [_animationView play];
}

- (void) goNext {
    NSLog(@"Button Pressed or Countdown Finished!");
    if (_nextClicked == YES || self.nextHandler == nil) {
        return;
    }
    self.nextHandler();
    _nextClicked = YES;
}

- (void)startCountdown {
    NSString *text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.enter"];
    [[CountdownManager sharedManager] startCountdownWithDuration:5 updateBlock:^(NSInteger secondsLeft) {
        [self.doneButton setTitle:[NSString stringWithFormat:@"%@(%ld)", text, (long)secondsLeft] forState:UIControlStateNormal];
    } completion:^{
        [self goNext];  // Call the same action as button press on completion
    }];
}




@end
