//
//  CameraAndMicrophoneResultView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/19.
//

#import "CameraAndMicrophoneResultView.h"
#import "Masonry/Masonry.h"
#import "AssetsUtil.h"
#import "UIColor+Util.h"
#import "VolumeView.h"
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"

@interface CameraAndMicrophoneResultView()
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *mirroBtn;
@property (nonatomic, assign) Boolean useMirro;
@property (nonatomic, strong) VolumeView *volumeView;


@end

@implementation CameraAndMicrophoneResultView

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
        _useMirro = NO;
        [self setupUI];
    }
    return self;
}

-(void) setupUI {
    _videoView = [UIView new];
    _videoView.layer.cornerRadius = 10;
    _videoView.clipsToBounds = YES;
    [self addSubview:_videoView];
    
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(43);
        make.width.equalTo(@273);
        make.height.equalTo(@205);
        make.centerY.equalTo(self.mas_centerY).offset(-30);
    }];
    
    _mirroBtn = [UIButton new];
    [_mirroBtn setImage:[AssetsUtil imageNamed:@"Checked"] forState:UIControlStateSelected];
    [_mirroBtn setImage:[AssetsUtil imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [_mirroBtn addTarget:self action:@selector(toggleMirro) forControlEvents:UIControlEventTouchUpInside];
    _mirroBtn.selected = _useMirro;
    [self addSubview:_mirroBtn];
    [_mirroBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@21);
        make.height.equalTo(@21);
        make.centerY.equalTo(_videoView.mas_centerY);
        make.left.equalTo(_videoView.mas_right).offset(40);
    }];
    
    UILabel *textLabel = [UILabel new];
    textLabel.font = [UIFont boldSystemFontOfSize:14];
    textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    textLabel.text = @"Mirror image";
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mirroBtn.mas_right).offset(12);
        make.centerY.equalTo(_mirroBtn.mas_centerY);
    }];
    
    _volumeView = [VolumeView new];
    [self addSubview:_volumeView];
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_videoView.mas_left);
        make.top.equalTo(_videoView.mas_bottom).offset(56);
        make.right.equalTo(self.mas_right);
    }];
}

- (void) toggleMirro {
    _useMirro = !_useMirro;
    _mirroBtn.selected = _useMirro;
    TRTCRenderParams *params = [TRTCRenderParams new];
    TRTCVideoMirrorType type = _useMirro == YES ? TRTCVideoMirrorTypeEnable : TRTCVideoMirrorTypeDisable;
    params.mirrorType = type;
    params.rotation = TRTCVideoRotation_90;
    [[TRTCCloud sharedInstance] setLocalRenderParams:params];
}

- (void)setVolume:(NSInteger)volume {
    _volume = volume;
    _volumeView.volume = volume;
}

- (void)toggleVideo:(Boolean)on {
    if (on == YES) {

        TRTCRenderParams *params = [TRTCRenderParams new];
        params.rotation = TRTCVideoRotation_90;
        TRTCVideoMirrorType type = _useMirro == YES ? TRTCVideoMirrorTypeEnable : TRTCVideoMirrorTypeDisable;
        params.mirrorType = type;
        [[TRTCCloud sharedInstance] setLocalRenderParams: params];

        [[TRTCCloud sharedInstance] startLocalPreview:YES view:_videoView];
    } else {
        [[TRTCCloud sharedInstance] stopLocalPreview];
    }
}


@end
