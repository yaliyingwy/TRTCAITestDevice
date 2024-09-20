//
//  LanguageGuideView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import "LanguageGuideView.h"
#import "LanguageSelectorView.h"
#import "Masonry/Masonry.h"
#import "LanguageManager.h"

@interface LanguageGuideView()
@property (strong, nonatomic) LanguageSelectorView *languageSelectorView;

@end

@implementation LanguageGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) setupContentView {
    self.titleLabel.text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.select.language"];
    _languageSelectorView = [LanguageSelectorView new];
    [self addSubview:_languageSelectorView];
    _languageSelectorView.languageOptions = _languageOptions;
    _languageSelectorView.selectionHandler = _selectionHandler;
    [_languageSelectorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top).offset(43);
            make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setLanguageOptions:(NSArray<NSDictionary *> *)languageOptions {
    _languageOptions = languageOptions;
    _languageSelectorView.languageOptions = languageOptions;
}

- (void)setSelectionHandler:(void (^)(NSDictionary * _Nonnull))selectionHandler {
    _languageSelectorView.selectionHandler = selectionHandler;
}

@end
