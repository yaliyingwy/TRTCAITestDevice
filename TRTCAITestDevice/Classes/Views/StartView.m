//
//  StartView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import "StartView.h"
#import "WelcomeView.h"

#import "LanguageManager.h"
#import "Masonry/Masonry.h"

@interface StartView()

@property (nonatomic, strong) WelcomeView *welcomeView;


@end

@implementation StartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) setupGuideView {
    _guideView = [LanguageGuideView new];
    [self addSubview:_guideView];
    _guideView.languageOptions = @[

    ];
    __weak typeof(self) weakSelf = self;
    _guideView.selectionHandler = ^(NSDictionary * _Nonnull selectedLanguage) {
        [[LanguageManager sharedManager] setCurrentLanguage:[selectedLanguage objectForKey:@"code"]];
        if (weakSelf.detectDelegate) {
            [weakSelf.detectDelegate onDetectDone: DectectLanguagePage];
        }
    };
    [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.top.equalTo(_welcomeView.mas_bottom).offset(12);
    }];
}

-(void) setupResultView {
    _welcomeView = [WelcomeView new];
    [self addSubview:_welcomeView];
    [_welcomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@400);
    }];
}




@end
