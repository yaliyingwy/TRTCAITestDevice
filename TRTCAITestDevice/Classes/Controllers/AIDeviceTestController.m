//
//  NetworkController.m
//  Pods
//
//  Created by ywen on 2024/9/9.
//

#import "AIDeviceTestController.h"
#import "AIConversationView.h"
#import "Masonry/Masonry.h"
#import "NetworkDetectView.h"
#import "UIColor+Util.h"
#import "AssetsUtil.h"
#import "StartView.h"
#import "CameraAndMicrophoneDetectView.h"
#import "LanguageManager.h"
#import "CommonDefines.h"
#import "AISdkManager.h"
#import "PermissionManager.h"

typedef void (^SuccessCallback)(void);


@interface AIDeviceTestController()

@property (nonatomic, strong) UIView *navbarView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) AIConversationView *aiConversationView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) StartView *startView;
@property (nonatomic, strong) NetworkDetectView *networkDetectView;
@property (nonatomic, strong) CameraAndMicrophoneDetectView *cameraAndMicrophoneDetectView;

@property (nonatomic, copy) NSString *defaultLanguage;


@property (nonatomic, assign) ControlAICode currentAICode;

@property (nonatomic, assign) AIDeviceDetectType currentDetectType;
@property (nonatomic, assign) AISdkManager *aiSdkManager;
@property (nonatomic, strong) NSMutableArray<NSString *> *pendingMsg;

@property (nonatomic, strong) NSTimer *volumeTimer;
@property (nonatomic, assign) NSTimeInterval volumeZeroDuration;

@property (nonatomic, assign) Boolean volumeDetected;
@property (nonatomic, assign) Boolean videoDetected;
@property (nonatomic, assign) Boolean countdownTriggered;

@end

@implementation AIDeviceTestController

-(instancetype)init {
    if (self = [super init]) {
        _currentDetectType = DetectLanguage;
        _currentAICode = CodeNone;
        _defaultLanguage = [[LanguageManager sharedManager].currentLanguage copy];
        _aiSdkManager = [AISdkManager sharedInstance];
        _pendingMsg = [NSMutableArray array];
        _volumeZeroDuration = 0;
        _volumeDetected = NO;
        _videoDetected = NO;
        _countdownTriggered = NO;
        [self setupUI];
        [self setupConstraints];
        [[TRTCCloud sharedInstance] addDelegate:self];
        [_aiSdkManager addObserver:self forKeyPath:@"aiSpeaking" options:NSKeyValueObservingOptionNew context:nil];
        [_aiSdkManager addObserver:self forKeyPath:@"aiVolume" options:NSKeyValueObservingOptionNew context:nil];
        [_aiSdkManager addObserver:self forKeyPath:@"userVolume" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

#pragma mark - 处理ai说话关联逻辑

// KVO 回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"aiSpeaking"]) {
        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        
        // 将新值转换为 BOOL 类型
        BOOL aiSpeaking = [newValue boolValue];
        [self aiSpeakingChanged:aiSpeaking];
    } else if ([keyPath isEqualToString:@"userVolume"] && _currentDetectType == DetectMicrophone) {
        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        NSInteger volume = [newValue integerValue];
        self.cameraAndMicrophoneDetectView.resultView.volume = volume;
        if (volume > 0) {
            if (_volumeDetected == NO) {
                [self testMicrophoneResult: DetectResultSucc];
                _volumeDetected = YES;
            }
            [self resetVolumeTimer];
        } else if (_volumeDetected == NO)  {
            [self startVolumeTimer];
        }
    }
}


-(void) aiSpeakingChanged:(Boolean) isSpeaking {
    if (isSpeaking == YES && _pendingMsg.count > 0) {
        [self.aiConversationView.chatView updateMessageList: [_pendingMsg copy]];
        [_pendingMsg removeAllObjects];
    }
}

#pragma mark - 持续不说话检测

- (void)startVolumeTimer {
    if (!self.volumeTimer && self.volumeZeroDuration == 0) {
        self.volumeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleVolumeTimer) userInfo:nil repeats:YES];
    }
}

- (void)resetVolumeTimer {
    if (self.volumeTimer != nil) {
        [self.volumeTimer invalidate];
        self.volumeTimer = nil;
    }
}

- (void)handleVolumeTimer {
    self.volumeZeroDuration += 1.0;

    if (self.volumeZeroDuration >= 10.0 && self.volumeZeroDuration < 11.0) {
        // 执行 10 秒后的操作
        [self performActionAfterTenSeconds];
    }

    if (self.volumeZeroDuration >= 20.0 && self.volumeZeroDuration < 21.0) {
        // 执行 20 秒后的操作
        [self performActionAfterTwentySeconds];
        [self resetVolumeTimer];
    }
}

- (void)performActionAfterTenSeconds {
    // 在这里执行 10 秒后的操作
    [self controlAI:CodeDetectMicrophone10s success:^(NSString *taskID) {
        NSLog(@"User volume is 0 for 10 seconds");
    } maxTime:3];
}

- (void)performActionAfterTwentySeconds {
    // 在这里执行 20 秒后的操作
    __weak typeof(self) weakSelf = self;
    [self controlAI:CodeDetectMicrophone20s success:^(NSString *taskID) {
        NSLog(@"User volume is 0 for 20 seconds");
        [weakSelf testMicrophoneResult:DetectResultSucc];
    } maxTime:3];
}

#pragma mark - ui界面相关

- (void) setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F9"];
    _navbarView = [UIView new];
    _navbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navbarView];
    
    _logoView = [UIImageView new];
    UIImage *logoImage = [AssetsUtil imageNamed:@"NavLogo"];
    _logoView.image = logoImage;
    [_navbarView addSubview:_logoView];
    
    
    UIImage *backImage = [AssetsUtil imageNamed:@"NavBack"];
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn addTarget:self action:@selector(clickBack) forControlEvents: UIControlEventTouchUpInside];
    [_backBtn setImage:backImage forState:UIControlStateNormal];
    [_navbarView addSubview:_backBtn];
    
    
    
    _aiConversationView = [AIConversationView new];
    [self.view addSubview:_aiConversationView];
    
    _contentView = [UIView new];
    [self.view addSubview:_contentView];
}

-(void) setupConstraints {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [_navbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@51);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(statusBarHeight);
    }];
    
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navbarView.mas_centerY);
        make.right.equalTo(_navbarView.mas_right).offset(-24);
        make.width.equalTo(@(_logoView.image.size.width / _logoView.image.scale));
        make.height.equalTo(@(_logoView.image.size.height / _logoView.image.scale));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navbarView.mas_centerY);
        make.left.equalTo(_navbarView.mas_left).offset(32);
        make.width.equalTo(@(_backBtn.imageView.image.size.width / _backBtn.imageView.image.scale));
        make.height.equalTo(@(_backBtn.imageView.image.size.height / _backBtn.imageView.image.scale));
    }];

    
    [_aiConversationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.equalTo(_navbarView.mas_bottom).offset(15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12);
        make.right.equalTo(self.view.mas_centerX).offset(-6);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(_navbarView.mas_bottom).offset(15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12);
        make.left.equalTo(self.view.mas_centerX).offset(6);
    }];
}


-(void) setupStartView {
    _startView = [StartView new];
    [_contentView addSubview:_startView];
    _startView.detectDelegate = self;
    [_startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left);
        make.right.equalTo(_contentView.mas_right);
        make.top.equalTo(_contentView.mas_top);
        make.bottom.equalTo(_contentView.mas_bottom);
    }];
}

- (void) setupNetworkView {
    [self clearContentview];
    _networkDetectView = [NetworkDetectView new];
    _networkDetectView.detectDelegate = self;
    [_contentView addSubview:_networkDetectView];
    [_networkDetectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left);
        make.right.equalTo(_contentView.mas_right);
        make.top.equalTo(_contentView.mas_top);
        make.bottom.equalTo(_contentView.mas_bottom);
    }];
    
}

-(void) setupCameraView {
    __weak typeof(self) weakSelf = self;
    [self clearContentview];
    _cameraAndMicrophoneDetectView = [CameraAndMicrophoneDetectView new];
    _cameraAndMicrophoneDetectView.detectDelegate = self;
    [_contentView addSubview:_cameraAndMicrophoneDetectView];
    [_cameraAndMicrophoneDetectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left);
        make.right.equalTo(_contentView.mas_right);
        make.top.equalTo(_contentView.mas_top);
        make.bottom.equalTo(_contentView.mas_bottom);
    }];
    _cameraAndMicrophoneDetectView.guideView.nextHandler = ^{
        [weakSelf finishTest];
    };
}


- (void) clearContentview {
    for (UIView *subview in [_contentView.subviews copy]) {
        [subview removeFromSuperview];
    }
}

-(void) clickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化参数

- (void)setTrtcParams:(NSDictionary *)trtcParams {
    _trtcParams = trtcParams;
    [self setupStartView];
//    [self setupNetworkView];
    [self enterAIRoom];
}

- (void) enterAIRoom {
    TRTCParams *params = [TRTCParams new];
    params.sdkAppId = [[_trtcParams valueForKey:@"sdkAppId"] intValue];
    params.strRoomId = [_trtcParams valueForKey:@"roomId"];
    params.userId = [_trtcParams valueForKey:@"userId"];
    params.userSig = [_trtcParams valueForKey:@"userSig"];
    
    [[TRTCCloud sharedInstance] enterRoom:params appScene:TRTCAppSceneVideoCall];
    [[AISdkManager sharedInstance] setupTRTC];
    [[TRTCCloud sharedInstance] startLocalAudio:TRTCAudioQualitySpeech];
    
    [_aiSdkManager muteLocalAudio];
    [self startAIConversation];
    
    
    [self startLangSelect];
}



-(void) startAIConversation {
    __weak typeof(self) weakSelf = self;
    [self.aiTaskDelegate performAITask:StartAIConversation params:@{
            @"roomId": [_trtcParams valueForKey:@"roomId"],
            @"userId": [_trtcParams valueForKey:@"userId"],
            @"language": [LanguageManager sharedManager].currentLanguage,
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"startAIConversation: %@",  responseObject);
            [weakSelf.aiConversationView.chatView updateMessageList:@[[weakSelf.trtcParams valueForKey: @"welcomeMessage"]]];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"startAIConversation: %@",  error);
        }];
}


- (void) startLangSelect {
    __weak typeof(self) weakSelf = self;
    [self controlAI:CodeSelectLang success:^(NSString *taskID) {
        weakSelf.startView.guideView.languageOptions = [weakSelf.trtcParams objectForKey:@"languageConfig"];
    } maxTime:3];
}

-(void) startNetworkTest {
    __weak typeof(self) weakSelf = self;
    self.currentDetectType = DetectNetwork;
    [self controlAI:CodeDetectNetwork success:^(NSString *taskID) {
        TRTCSpeedTestParams *params = [TRTCSpeedTestParams new];
        // sdkAppID 为控制台中获取的实际应用的 AppID
        params.sdkAppId = [[weakSelf.trtcParams valueForKey:@"sdkAppId"] intValue];;
        params.userId =  [weakSelf.trtcParams valueForKey:@"userId"];
        params.userSig = [weakSelf.trtcParams valueForKey:@"userSig"];
        // 预期的上行带宽（kbps，取值范围： 10 ～ 5000，为 0 时不测试）
    //    params.expectedUpBandwidth = 5000;
        // 预期的下行带宽（kbps，取值范围： 10 ～ 5000，为 0 时不测试）
    //    params.expectedDownBandwidth = 5000;
        int ret =  [[TRTCCloud sharedInstance] startSpeedTest:params];
        NSLog(@"startSpeedTest: %d", ret);
        [weakSelf.networkDetectView.networkResultView startProgressTimer];
    } maxTime:3];

}

- (void) startCameraTest {
    __weak typeof(self) weakSelf = self;
    [self controlAI:CodeDetectCamera success:^(NSString *taskID) {
        weakSelf.currentDetectType = DetectCamera;
        [weakSelf.cameraAndMicrophoneDetectView.resultView toggleVideo:YES];
    } maxTime:3];
}

-(void) startMicrophoneTest {
    __weak typeof(self) weakSelf = self;
//    [self controlAI:CodeDetectMicrophone success:^(NSString *taskID) {
//
//    } maxTime:3];
    self.currentDetectType = DetectMicrophone;
    [self.cameraAndMicrophoneDetectView.guideView play];
    [[TRTCCloud sharedInstance] muteLocalAudio:NO];
    
    // 手动触发一次 KVO 回调
    [self observeValueForKeyPath:@"userVolume" ofObject:_aiSdkManager change:@{NSKeyValueChangeNewKey: @(_aiSdkManager.userVolume)} context:nil];
}

-(void) finishTest {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.completation) {
        self.completation(YES);
    }
}

#pragma mark - trtc 代理回调

- (void)onSendFirstLocalVideoFrame:(TRTCVideoStreamType)streamType {
    if (_videoDetected == NO) {
        [self testCameraResult: DetectResultSucc];
        _videoDetected = YES;
    }
}


- (void)onSpeedTestResult:(TRTCSpeedTestResult *)result {
    NSLog(@"onSpeedTestResult: %@", result);
    __weak typeof(self) weakSelf = self;
    ControlAICode code;
    if (result.quality == TRTCQuality_Excellent || result.quality == TRTCQuality_Good) {
        _networkDetectView.status = Good;
        code = CodeDetectNetworkGood;
    } else if (result.quality == TRTCQuality_Poor) {
        _networkDetectView.status = Poor;
        code = CodeDetectNetworkPoor;
    } else {
        _networkDetectView.status = Bad;
        code = CodeDetectNetworkBad;
    }
    
    [self controlAI:code success:^(NSString *taskID) {
        if (code == CodeDetectNetworkGood) {
            if (weakSelf.countdownTriggered == NO) {
                [weakSelf.networkDetectView.networkGuideView startCountdown];
                weakSelf.countdownTriggered = YES;
            }
            
        }
    } maxTime:3];
}

#pragma mark - 设备检测代理回调

- (void)onDetectDone:(AIDetectPage)page {
    
    __weak typeof(self) weakSelf = self;
    if (page == DectectLanguagePage) {
        [self setupNetworkView];
        if (![[LanguageManager sharedManager].currentLanguage isEqualToString: _defaultLanguage]) {
            [self updateAIConversion:^{
                [weakSelf startNetworkTest];
            }];
        } else {
            [weakSelf startNetworkTest];
        }
        return;
    }
    if (page == DectectNetworkPage) {
        [self setupCameraView];
        [self startCameraTest];
        return;
    }
}

- (void)onDetectResult:(AIDeviceDetectType)type result:(AIDeviceDetectResult)result {

    if (type == DetectCamera) {
        [self testCameraResult:result];
    }
    
    if (type == DetectMicrophone) {
        [self testMicrophoneResult:result];
    }
}

-(void) testCameraResult: (AIDeviceDetectResult) result {
    ControlAICode code;
    __weak typeof(self) weakSelf = self;
    code = result == DetectResultSucc ? CodeDetectCameraSuccess : CodeDetectCameraNoPermission;
    [self controlAI:code success:^(NSString *taskID) {
        [weakSelf startMicrophoneTest];
    } maxTime:3];
}

-(void) testMicrophoneResult:(AIDeviceDetectResult) result {
    ControlAICode code;
    __weak typeof(self) weakSelf = self;
    [[TRTCCloud sharedInstance] muteLocalAudio:YES];
    code = result == DetectResultSucc ? CodeDetectMicrophoneSuccess : CodeDetectMicrophoneNoPermission;
    [self controlAI:code success:^(NSString *taskID) {
        [weakSelf.cameraAndMicrophoneDetectView.guideView detectDone];
    } maxTime:3];
}

-(void) onDetectRetry:(AIDetectPage)type {
    if (type == DetectNetwork) {
        _networkDetectView.status = Detecting;
        [self startNetworkTest];
    }
}

-(void) controlAI: (ControlAICode) code success:(void (^)(NSString *taskID)) success maxTime:(NSInteger) maxTime {
    __weak typeof(self) weakSelf = self;
    _currentAICode = code;
    [self.aiTaskDelegate performAITask:ControlAIConversation params:@{
            @"roomId": [_trtcParams valueForKey:@"roomId"],
            @"commandCode": @(code)
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"controlAI success: %@", responseObject);
            NSDictionary *data =  [responseObject objectForKey:@"data"];
            NSString *commandMessage = [data objectForKey:@"commandMessage"];
            if (commandMessage != nil && commandMessage.length > 0) {
                [weakSelf.pendingMsg addObject: commandMessage];
            }
        [weakSelf.aiSdkManager addAISpeakDone:[NSString stringWithFormat:@"%ld", code] callback:success maxTime: maxTime];

        } failure:^(NSError * _Nonnull error) {
            NSLog(@"controlAI error: %@", error);
        }];
}

- (void) updateAIConversion: (SuccessCallback) success {
    [self.aiTaskDelegate performAITask:UpdateAIConversation params:@{
            @"roomId": [_trtcParams valueForKey:@"roomId"],
            @"userId": [_trtcParams valueForKey:@"userId"],
            @"language": [LanguageManager sharedManager].originLangCode,
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"updateAIConversion success: %@", responseObject);
        if (success != nil) {
            success();
        }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"updateAIConversion error: %@", error);
        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillDisappear:(BOOL)animated {
    [[TRTCCloud sharedInstance] exitRoom];
    [_aiSdkManager removeObserver:self forKeyPath:@"aiSpeaking"];
    [_aiSdkManager removeObserver:self forKeyPath:@"aiVolume"];
    [_aiSdkManager removeObserver:self forKeyPath:@"userVolume"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkPermissions];
}

#pragma mark - 权限检查

-(void) checkPermissions
{
//    if (UserSingleton.role != PPUserRoleStu) {
//        return;
//    }
    if ([PermissionManager isCameraAvailable:^(BOOL granted) {
        if (!granted) {
            [self noAuthorizationToSet:NO];
        }
        if (self.aiTaskDelegate && [self.aiTaskDelegate respondsToSelector:@selector(onDetectPermission:hasPermission:)]) {
            [self.aiTaskDelegate onDetectPermission:DetectCamera hasPermission:granted];
        }
    }]) {
        NSLog(@"摄像头有权限");
    }else{
        NSLog(@"摄像头待获取");
    }
    if ([PermissionManager isMicphoneAvailable:^(BOOL granted) {
        if (!granted) {
            [self noAuthorizationToSet:YES];
            //[LAEventLog uploadEventLogId:LAEventMicphoneOpenFail content:@"没有麦克风权限"];
        }
        if (self.aiTaskDelegate && [self.aiTaskDelegate respondsToSelector:@selector(onDetectPermission:hasPermission:)]) {
            [self.aiTaskDelegate onDetectPermission:DetectMicrophone hasPermission:granted];
        }
    }]) {
        NSLog(@"麦克风有权限");
    }else{
        NSLog(@"麦克风待获取");
    }
}

-(void)noAuthorizationToSet:(BOOL)isMic {
    NSString *title = NSLocalizedString(@"权限获取", nil);
    NSString *message = isMic?NSLocalizedString(@"请前往设置打开麦克风权限" , nil):NSLocalizedString(@"请前往设置打开摄像头权限" , nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    NSMutableAttributedString *AttributedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [AttributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [[AttributedTitle string] length])];
    [alert setValue:AttributedTitle forKey:@"attributedTitle"];
 
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"去设置", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * appSettingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:appSettingURL]){
            [[UIApplication sharedApplication] openURL:appSettingURL options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
            }];
         }
        [alert dismissViewControllerAnimated:NO completion:^{
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
