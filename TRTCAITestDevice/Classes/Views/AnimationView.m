//
//  AnimationView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//

#import "AnimationView.h"
#import <AVFoundation/AVFoundation.h>
#import "Lottie.h"
#import "Masonry/Masonry.h"
#import "AssetsUtil.h"
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"

@interface AnimationView()
{
    AVAudioPlayer  *cupAudio;
}
@property(nonatomic,strong) LOTAnimationView *lotView;
@property (nonatomic, copy) NSString *jsonName;
@property (nonatomic, copy) NSString *audio;
@end

@implementation AnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) setupLottie:(NSString *) json {
    if (_lotView) {
        [_lotView removeFromSuperview];
        _lotView = nil;
    }
    _lotView = [LOTAnimationView animationNamed:json inBundle:[AssetsUtil aiBundle]];
    _lotView.userInteractionEnabled = YES;
    _lotView.contentMode = UIViewContentModeScaleAspectFill;
    _lotView.animationProgress = 1;
    _lotView.loopAnimation = YES;
    // 创建UITapGestureRecognizer
     UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_lotView addGestureRecognizer:tapRecognizer];
    [self addSubview:_lotView];
    [_lotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    

    
}

- (void)play {
    _lotView.animationProgress = 0;
    
    [_lotView playToProgress:1 withCompletion:^(BOOL animationFinished) {
        NSLog(@"]]]");
    }];
    [self gunShot];
}

// 实现handleTap:方法来处理点击事件
- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self gunShot];
    }
}

- (void)configureWithJson:(NSString *)json audio:(NSString *)audio {
    _jsonName = json;
    _audio = audio;
    [self setupLottie:json];
}

//烟花音效
-(void)gunShot
{
    if (_audio == nil) {
        return;
    }
    NSString *audioPath = [[AssetsUtil aiBundle] pathForResource:_audio ofType:@"mp3"];
    if(audioPath)
    {
        TXAudioMusicParam *params = [TXAudioMusicParam new];
        params.path = audioPath;
        params.publish = NO;
        params.isShortFile = YES;
//        params.loopCount = 2;
        params.ID = 123;
        [[[TRTCCloud sharedInstance] getAudioEffectManager] startPlayMusic:params onStart:^(NSInteger errCode) {
                    
        } onProgress:^(NSInteger progressMs, NSInteger durationMs) {
            
        } onComplete:^(NSInteger errCode) {
            
        }];
    }
}


@end
