//
//  AIResultView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import "AIResultView.h"
#import "AssetsUtil.h"
#import "Masonry/Masonry.h"

@implementation AIResultView

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
        [self setupBackground];
    }
    return self;
}


-(void) setupBackground {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12;
    self.layer.shadowColor = [UIColor colorWithRed:126/255.0 green:147/255.0 blue:255/255.0 alpha:0.2500].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 20;

    // 加载图片
    UIImage *backgroundImage = [AssetsUtil imageNamed:@"WifiBackground"];

    // 使用 UIImageView
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [self addSubview:backgroundImageView];
    [self sendSubviewToBack:backgroundImageView]; // 确保背景图片在最底层
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

@end
