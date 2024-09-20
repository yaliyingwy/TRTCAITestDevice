//
//  VolumeView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/19.
//

#import "VolumeView.h"
#import "Masonry/Masonry.h"
#import "UIColor+Util.h"
#import "AssetsUtil.h"

@interface VolumeView()
@property (nonatomic, assign) NSInteger numberOfBars;

@end

@implementation VolumeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        _numberOfBars = 26;
        _volume = 0;
        [self createUI];
    }
    return self;
}

-(void) createUI {
    
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [AssetsUtil imageNamed:@"MicroPhone"];
    imageView.image = image;
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(image.size.width / image.scale));
        make.height.equalTo(@(image.size.height / image.scale));
    }];
    
    UIView *preBar;
    for (int i = 0; i < _numberOfBars; i++) {
        UIView *bar = [UIView new];
        bar.tag = i + 1;
        bar.backgroundColor = [UIColor colorWithHexString:@"#ECEEFF"];
        bar.layer.cornerRadius = 3;
        [self addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@6);
            make.height.equalTo(@19);
            make.centerY.equalTo(self.mas_centerY);
            if (preBar != nil) {
                make.left.equalTo(preBar.mas_right).offset(7);
            } else {
                make.left.equalTo(imageView.mas_right).offset(7);
            }
        }];
        
        preBar = bar;
    }
}

- (void)setVolume:(NSInteger)volume {
    _volume = volume;
    // 计算每个音量条代表的音量范围
    CGFloat volumePerBar = 100.0 / _numberOfBars;
    // 计算当前音量值激活了多少个音量条
    NSInteger activeBars = (NSInteger)ceil(volume / volumePerBar);
    
    for (int i = 0; i < _numberOfBars; i++) {
        UIView *bar = [self viewWithTag:i + 1];
        bar.backgroundColor = i + 1 > activeBars ? [UIColor colorWithHexString:@"#ECEEFF"] :  [UIColor colorWithHexString:@"#7580E5"];
    }
}

@end
