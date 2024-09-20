//
//  LanguageSelectorView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import "LanguageSelectorView.h"
#import "Masonry/Masonry.h"
#import "AssetsUtil.h"
#import "UIColor+Util.h"

@interface LanguageSelectorView()
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation LanguageSelectorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setLanguageOptions:(NSArray<NSDictionary *> *)languageOptions {
    _languageOptions = languageOptions;
    [self reloadLanguages];
}



- (void)reloadLanguages {
    // Remove all existing language buttons
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self.languageOptions enumerateObjectsUsingBlock:^(NSDictionary *languageDict, NSUInteger idx, BOOL *stop) {
        NSString *languageName = languageDict[@"name"];
        UIButton *languageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *seletedImage = [AssetsUtil imageNamed:@"ButtonSeleted"];
        UIImage *normalImage = [AssetsUtil imageNamed:@"ButtonNormal"];
        [languageButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [languageButton setBackgroundImage:seletedImage forState:UIControlStateSelected];
        [languageButton setTitle:languageName forState:UIControlStateNormal];
        [languageButton setTitleColor:[UIColor colorWithHexString:@"#3A3C53"] forState:UIControlStateSelected];
        [languageButton setTitleColor:[UIColor colorWithHexString:@"#3A3C53"] forState:UIControlStateNormal];
        languageButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [languageButton addTarget:self action:@selector(languageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:languageButton];
        
        NSUInteger row = idx / 2;
        Boolean isLeft = idx % 2 == 0;
        
        [languageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (isLeft) {
                make.right.equalTo(self.mas_centerX).offset(-10);
            } else {
                make.left.equalTo(self.mas_centerX).offset(10);
            }
            make.top.equalTo(self.mas_top).offset(20 + row * 56);
            make.height.equalTo(@36);
            make.width.equalTo(@160);
        }];
    }];

}

- (void)languageButtonTapped:(UIButton *)sender {
    if (_selectedBtn) {
        _selectedBtn.selected = NO;
    }
    _selectedBtn = sender;
    _selectedBtn.selected = YES;
    NSString *languageName = sender.titleLabel.text;
    NSDictionary *selectedLanguage = [self.languageOptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", languageName]].firstObject;
    if (self.selectionHandler && selectedLanguage) {
        self.selectionHandler(selectedLanguage);
    }
}

@end
