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

@property (nonatomic, copy) NSString *aiUserId;
@property (nonatomic, copy) NSString *defaultLanguage;

@property (nonatomic, assign) Boolean aiSpeaking;
@property (nonatomic, assign) Boolean aiTextEnd;
@property (nonatomic, assign) ControlAICode currentAICode;

@property (nonatomic, copy) SuccessCallback aiSpeakEndCallback;
@property (nonatomic, assign) AIDeviceDetectType currentDetectType;
@property (nonatomic, assign) NSInteger aiVolumeZeroCount;

@property (nonatomic, strong) NSMutableArray *pendingMsg;

@property (nonatomic, strong) NSString *aiSpeakEndCallbackIdentifier;


@end

@implementation AIDeviceTestController

-(instancetype)init {
    if (self = [super init]) {
        _aiSpeaking = NO;
        _aiTextEnd = YES;
        _aiVolumeZeroCount = 0;
        _currentDetectType = DetectLanguage;
        _currentAICode = CodeNone;
        _pendingMsg = [NSMutableArray new];
        _defaultLanguage = [[LanguageManager sharedManager].currentLanguage copy];
        [self setupUI];
        [self setupConstraints];
        [[TRTCCloud sharedInstance] addDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

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

- (void)setAiSpeakEndCallback:(SuccessCallback)aiSpeakEndCallback {
    _aiSpeakEndCallback = aiSpeakEndCallback;
    NSString *callbackIdentifier = [[NSUUID UUID] UUIDString];
    self.aiSpeakEndCallbackIdentifier = callbackIdentifier;
    // 设置超时逻辑
    NSTimeInterval timeoutInterval = 10.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 检查标识符是否仍然匹配
        if (self.aiSpeakEndCallback != nil && [self.aiSpeakEndCallbackIdentifier isEqualToString:callbackIdentifier]) {
            // 如果匹配，并且aiSpeakEndCallback还没有被设置为nil，则执行它
            [self doAiSpeakEndCallback];
        }
    });
}

- (void) clearContentview {
    for (UIView *subview in [_contentView.subviews copy]) {
        [subview removeFromSuperview];
    }
}

-(void) clickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    [[TRTCCloud sharedInstance] startLocalAudio:TRTCAudioQualitySpeech];
    
    [self startAIConversation];
    [self detectVolume];
    
    [self startLangSelect];
}

- (void) detectVolume {
    TRTCAudioVolumeEvaluateParams *params = [TRTCAudioVolumeEvaluateParams new];
    params.interval = 800;
    [[TRTCCloud sharedInstance] enableAudioVolumeEvaluation: YES withParams: params];
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
    [self controlAI:CodeSelectLang success:^{
        weakSelf.startView.guideView.languageOptions = [weakSelf.trtcParams objectForKey:@"languageConfig"];
    }];
}

-(void) startNetworkTest {
    __weak typeof(self) weakSelf = self;
    self.currentDetectType = DetectNetwork;
    [self controlAI:CodeDetectNetwork success:^{
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
    }];

}

- (void) startCameraTest {
    __weak typeof(self) weakSelf = self;
    [self controlAI:CodeDetectCamera success:^{
        weakSelf.currentDetectType = DetectCamera;
        [weakSelf.cameraAndMicrophoneDetectView.resultView toggleVideo:YES];
    }];
}

-(void) startMicrophoneTest {
    __weak typeof(self) weakSelf = self;
    [self controlAI:CodeDetectMicrophone success:^{
        weakSelf.currentDetectType = DetectMicrophone;
        [weakSelf.cameraAndMicrophoneDetectView.guideView play];
    }];
}

-(void) finishTest {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSendFirstLocalVideoFrame:(TRTCVideoStreamType)streamType {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self testCameraResult: DetectResultSucc];
    });
}

- (void)onUserVoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes totalVolume:(NSInteger)totalVolume {
    
    for (TRTCVolumeInfo *volumeInfo in userVolumes) {
//
        if (volumeInfo.userId == nil || [volumeInfo.userId isEqualToString:@""]) {
            if (_cameraAndMicrophoneDetectView != nil && _currentDetectType == DetectMicrophone) {
                _cameraAndMicrophoneDetectView.resultView.volume = volumeInfo.volume;
                if (volumeInfo.volume > 0) {
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        [self testMicrophoneResult: DetectResultSucc];
                    });
                }
            }
            
//            NSLog(@"volumeInfo: %ld", volumeInfo.volume);
        } else if ([volumeInfo.userId isEqualToString:_aiUserId] && self.currentAICode != CodeNone) {
            NSLog(@"ai %ld volumeInfo: %ld ", _currentAICode,  volumeInfo.volume);
            if (volumeInfo.volume > 0) {
                self.aiSpeaking = YES;
                self.aiVolumeZeroCount = 0; // 重置计数器
            } else if (_aiTextEnd && self.aiSpeaking == YES) {
                // 如果音量为0，增加计数器
               self.aiVolumeZeroCount++;
               // 检查是否连续两次音量为0
                if (self.aiVolumeZeroCount >= 2) {
                    self.aiSpeaking = NO;
                    self.aiVolumeZeroCount = 0; // 重置计数器
                }
            }
        } else {
            NSLog(@"none ai volumeInfo: %@ %ld %@", volumeInfo.userId, volumeInfo.volume, _aiUserId);
        }
    }
}

-(void)setAiSpeaking:(Boolean)aiSpeaking {
    if (_aiSpeaking == aiSpeaking) {
        return;
    }
    NSLog(@"setAiSpeaking: %d -> %d", _aiSpeaking, aiSpeaking);
    _aiSpeaking = aiSpeaking;
    [self doAiSpeakEndCallback];
    
    if (_aiSpeaking == YES && self.pendingMsg.count > 0) {
        [self.aiConversationView.chatView updateMessageList: [self.pendingMsg copy]];
        [self.pendingMsg removeAllObjects];
    }
}

-(void) doAiSpeakEndCallback {
    if (_aiSpeaking == NO && self.aiSpeakEndCallback != nil) {
        self.aiSpeakEndCallback();
        self.aiSpeakEndCallback = nil;
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
    
    [self controlAI:code success:^{
        if (code == CodeDetectNetworkGood) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [weakSelf.networkDetectView.networkGuideView startCountdown];
            });
            
        }
    }];
}

- (void)onUserAudioAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"onUserAudioAvailable: %@ %d", userId, available);
    [[TRTCCloud sharedInstance] muteRemoteAudio:userId mute:!available];
    
}

- (void)onRecvCustomCmdMsgUserId:(NSString *)userId cmdID:(NSInteger)cmdID seq:(UInt32)seq message:(NSData *)message {
//    NSLog(@"onRecvCustomCmdMsgUserId: %@, %ld, %d, %@", userId, cmdID, seq, message);
    if (cmdID == 1) {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:message options:NSJSONReadingMutableContainers error:&error];
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            [self handleAIMessage: jsonObject];
        }
    }
    
}

-(void) handleAIMessage: (NSDictionary *) message{
    NSInteger type = [[message objectForKey:@"type"] integerValue];
    NSDictionary *payload = [message objectForKey:@"payload"];
    if (type == 10000) {
        Boolean isEnd = [[payload objectForKey:@"end"] boolValue];
        _aiTextEnd = isEnd;
        NSLog(@"%@ %d", [payload objectForKey:@"text"], isEnd);
    }
}


- (void)onEnterRoom:(NSInteger)result {
    NSLog(@"onEnterRoom: %ld", result);
}

- (void)onRemoteUserEnterRoom:(NSString *)userId {
    _aiUserId = userId;
    NSLog(@"onRemoteUserEnterRoom: %@", userId);
}

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
    [self controlAI:code success:^{
        [weakSelf startMicrophoneTest];
    }];
}

-(void) testMicrophoneResult:(AIDeviceDetectResult) result {
    ControlAICode code;
    __weak typeof(self) weakSelf = self;
    code = result == DetectResultSucc ? CodeDetectMicrophoneSuccess : CodeDetectMicrophoneNoPermission;
    [self controlAI:code success:^{
        [weakSelf.cameraAndMicrophoneDetectView.guideView detectDone];
    }];
}

-(void) onDetectRetry:(AIDetectPage)type {
    if (type == DetectNetwork) {
        _networkDetectView.status = Detecting;
        [self startNetworkTest];
    }
}

-(void) controlAI: (ControlAICode) code success:(SuccessCallback) success {
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
                [weakSelf.pendingMsg addObject:commandMessage];
            }
            weakSelf.aiTextEnd = NO;
            weakSelf.aiSpeakEndCallback = success;
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
}

@end
