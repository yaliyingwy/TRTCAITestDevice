//
//  AISdkManager.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/22.
//

#import "AISdkManager.h"

@interface AISdkManager()
@property (nonatomic, strong) dispatch_block_t delayedBlock;
@end

@implementation AISdkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskDictionary = [NSMutableDictionary dictionary];
        _aiSpeaking = NO;
        _aiTextEnd = YES;
        _aiVolume = 0;
        _userVolume = 0;
        _aiStatus = AIUnknown;
        _aiMessageList = [NSMutableArray new];
        // 初始化代码
        [self addObserver:self forKeyPath:@"aiTextEnd" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"aiVolume" options:NSKeyValueObservingOptionNew context:nil];

    }
    return self;
}

+ (instancetype)sharedInstance {
    static AISdkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)muteLocalAudio {
//    [[TRTCCloud sharedInstance] callExperimentalAPI: @"{\"api\":\"setLocalAudioMuteAction\",\"params\":{\"volumeEvaluation\":1}}"];
    [[TRTCCloud sharedInstance] callExperimentalAPI: @"{\"api\":\"setLocalAudioMuteMode\",\"params\":{\"mode\":0}}"];
    [[TRTCCloud sharedInstance] muteLocalAudio:YES];
}

- (void)addAISpeakDone:(NSString *)taskID callback:(void (^)(NSString * _Nonnull))callback maxTime:(NSTimeInterval)maxTime {
    // Create a block that will execute the success callback
    dispatch_block_t taskBlock = ^{
        if (callback) {
            callback(taskID);
        }
    };
    
    // Store the block in the dictionary
    @synchronized (self.taskDictionary) {
        self.taskDictionary[taskID] = taskBlock;
        self.lastTaskId = taskID;
    }
    
    if (maxTime == 0) {
        return;
    }
    
    // Schedule the block to be executed after maxTime if not already executed
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @synchronized (self.taskDictionary) {
            if (self.taskDictionary[taskID]) {
                dispatch_block_t block = self.taskDictionary[taskID];
                block();
                [self.taskDictionary removeObjectForKey:taskID];
            }
        }
    });
}

-(void)triggerAISpeakDoneCallback:(NSString *)taskID {
    @synchronized (self.taskDictionary) {
        if (self.taskDictionary[taskID]) {
            dispatch_block_t block = self.taskDictionary[taskID];
            block();
            [self.taskDictionary removeObjectForKey:taskID];
        }
    }
}

-(void)setupTRTC {
    [[TRTCCloud sharedInstance] addDelegate:self];
    TRTCAudioVolumeEvaluateParams *params = [TRTCAudioVolumeEvaluateParams new];
    params.enableVadDetection = YES;
    params.interval = 300;
    [[TRTCCloud sharedInstance] enableAudioVolumeEvaluation:YES withParams:params];
}

-(void)onRemoteUserEnterRoom:(NSString *)userId {
    _aiUserId = userId;
}

- (void)onUserAudioAvailable:(NSString *)userId available:(BOOL)available {
    [[TRTCCloud sharedInstance] muteRemoteAudio:userId mute:!available];
}


- (void)onUserVoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes totalVolume:(NSInteger)totalVolume {
    for (TRTCVolumeInfo *volumeInfo in userVolumes) {
        if (volumeInfo.userId == nil || [volumeInfo.userId isEqualToString:@""]) {
            if (_userVolume != volumeInfo.volume) {
                self.userVolume = volumeInfo.volume;
            }
           
        } else if (_aiUserId != nil && [volumeInfo.userId isEqualToString:_aiUserId] ) {
            if (self.aiVolume != volumeInfo.volume) {
                self.aiVolume = volumeInfo.volume;
            }
        }
    }
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
    NSString *userId = [message objectForKey:@"sender"];
    NSDictionary *payload = [message objectForKey:@"payload"];
    if (type == AIMessageTypeText) {
        Boolean isEnd = [[payload objectForKey:@"end"] boolValue];
        NSString *text = [payload objectForKey:@"text"];
        _aiTextEnd = isEnd;;
        NSLog(@"handleAIMessage %@ %@ %d", userId, text , isEnd);
        if (text != nil && text.length > 0) {
            [self.aiMessageList addObject:text];
        }
    }
    
    if (type == AIMessageTypeStatus) {
        NSInteger status = [[payload objectForKey:@"state"] integerValue];
        NSLog(@"handleAIStatus %@ %ld", userId, status);
        self.aiStatus = status;
    }
}

// KVO 回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"aiTextEnd"] || [keyPath isEqualToString:@"aiVolume"]) {
        [self scheduleCheckAISpeaking];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 检查 aiSpeaking 和 aiVolume 的值，并在满足条件时触发指定函数
- (void)checkAISpeaking {
    self.aiSpeaking = self.aiTextEnd == NO || self.aiVolume > 0;
}

- (void)scheduleCheckAISpeaking {
    if (self.aiVolume > 0 && self.aiSpeaking == NO) {
        self.aiSpeaking = YES;
        return;
    }
    // 取消之前的延迟调用
    if (self.delayedBlock) {
        dispatch_block_cancel(self.delayedBlock);
    }
    
    // 创建新的延迟调用
    __weak typeof(self) weakSelf = self;
    self.delayedBlock = dispatch_block_create(0, ^{
        [weakSelf checkAISpeaking];
    });
    
    // 延迟 100 毫秒调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), self.delayedBlock);
}


- (void)setAiSpeaking:(Boolean)aiSpeaking {
    if (_aiSpeaking == aiSpeaking) {
        return;
    }
    [self willChangeValueForKey:@"aiSpeaking"];
    _aiSpeaking = aiSpeaking;
    [self didChangeValueForKey:@"aiSpeaking"];
    if (aiSpeaking == NO && _lastTaskId != nil) {
        [self triggerAISpeakDoneCallback:_lastTaskId];
    }
}

- (void)interruptAI {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
          
    // 将时间戳转换为毫秒级别的整数
    NSInteger timestamp = (NSInteger)(timeInterval * 1000);
    NSDictionary *dic = @{
        @"type": @(AICommandTypeInterrupt),
        @"sender": _userId,
        @"receiver": @[_aiUserId],
        @"payload": @{
            @"id": [[NSUUID UUID] UUIDString],
            @"timestamp": @(timestamp)
        }
    };
    [self sendCustomerMessage:dic];
}

- (void)sendMessageToAI:(NSString *)msg {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
          
    // 将时间戳转换为毫秒级别的整数
    NSInteger timestamp = (NSInteger)(timeInterval * 1000);
    NSDictionary *dic = @{
        @"type": @(AICommandTypeText),
        @"sender": _userId,
        @"receiver": @[_aiUserId],
        @"payload": @{
            @"id": [[NSUUID UUID] UUIDString],
            @"message": msg,
            @"timestamp": @(timestamp)
        }
    };
    [self sendCustomerMessage:dic];

}

-(void) sendCustomerMessage: (NSDictionary *) dic {
    NSInteger cmdID = 2;
    NSError *error;
    // 将字典转换为 JSON 数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    
    if (!jsonData) {
        NSLog(@"转换字典为 JSON 数据时出错: %@", error.localizedDescription);
        return;
    }
    [[TRTCCloud sharedInstance] sendCustomCmdMsg:cmdID data:jsonData reliable:YES ordered:YES];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"aiTextEnd"];
    [self removeObserver:self forKeyPath:@"aiVolume"];

}




@end
