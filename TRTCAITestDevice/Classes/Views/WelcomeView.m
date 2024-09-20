//
//  WelcomeView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import "WelcomeView.h"
#import "LanguageManager.h"
#import "AssetsUtil.h"
#import "UIColor+Util.h"
#import "Masonry/Masonry.h"

@interface WelcomeView()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation WelcomeView

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
        [self setupUI];
    }
    return self;
}

-(void) setupUI {
    _textLabel = [UILabel new];
    _textLabel.font = [UIFont systemFontOfSize: 18];
    _textLabel.textColor = [UIColor colorWithHexString:@"#3A3C53"];
    _textLabel.text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.welcome"];
    [self addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_centerY).offset(60);
    }];

    _imageView = [UIImageView new];
    UIImage *image = [AssetsUtil imageNamed:@"TigoWelcome"];
    _imageView.image = image;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_centerY).offset(20);
        make.width.equalTo(@(image.size.width / image.scale));
        make.height.equalTo(@(image.size.height / image.scale));
    }];
}

@end
