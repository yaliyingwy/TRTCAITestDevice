//
//  NetworkResultView.m
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import "NetworkResultView.h"
#import "Masonry/Masonry.h"
#import "AssetsUtil.h"
#import "LanguageManager.h"
#import "ProgressCircleView.h"

@interface NetworkResultView()

@property (nonatomic, strong) ProgressCircleView *progressView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (strong, nonatomic) NSTimer *progressTimer;
@property (assign, nonatomic) CGFloat progressTime;
@property (assign, nonatomic) CGFloat fakeSeconds;

@end

@implementation NetworkResultView


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
        _fakeSeconds = 3.6;
        [self setupUI];
    }
    return self;
}

-(void) setupUI {
    _textLabel = [UILabel new];
    _textLabel.text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.network.detecting"];
    _textLabel.numberOfLines = 0;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_centerY).offset(60);
        make.width.lessThanOrEqualTo(self).multipliedBy(0.6);
    }];
    
    _progressView = [ProgressCircleView new];
   
    [self addSubview:_progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@140);
        make.height.equalTo(@140);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_centerY).offset(20);
    }];
    _progressView.hidden = YES;
    
    _imageView = [UIImageView new];
    _imageView.hidden = YES;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_centerY).offset(20);
    }];
}

- (void)setStatus:(NetworkDetectStatus)status {
//    if (_status == status) {
//        return;
//    }
    _status = status;
    NSString *text;
    if (status != Detecting) {
        NSString *imageName;
        if (status == Good) {
            imageName = @"WifiGood";
            text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.network.good"];
        } else if (status == Bad) {
            imageName = @"WifiBad";
            text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.network.bad"];
        } else {
            imageName = @"WifiPoor";
            text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.network.poor"];
        }
        UIImage *image = [AssetsUtil imageNamed: imageName];
        _imageView.image = image;
        _imageView.hidden = NO;
        _progressView.progress = 100;
        _progressView.hidden = YES;
        [self stopProgressTimer];
    } else {
        _imageView.hidden = YES;
        _progressView.progress = 0;
        text = [[LanguageManager sharedManager] localizedStringForKey:@"ai.network.detecting"];
    }
    _textLabel.text = text;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (_imageView.image && _imageView.image.scale > 0) {
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(_imageView.image.size.width / _imageView.image.scale));
            make.height.equalTo(@(_imageView.image.size.height / _imageView.image.scale));
        }];
    }

    [super updateConstraints];
}

- (void)startProgressTimer {
    
    [self stopProgressTimer]; // 先停止之前的计时器
    _progressView.hidden = NO;
    self.progressTime = 0;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:_fakeSeconds / 100 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)stopProgressTimer {
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

- (void)updateProgress {
    self.progressTime += 0.02;
    CGFloat progress = self.progressTime / _fakeSeconds; // 2秒内完成
    if (progress >= 0.99) {
        progress = 0.99;
        [self stopProgressTimer];
    }
    _progressView.progress = progress;
}

@end
