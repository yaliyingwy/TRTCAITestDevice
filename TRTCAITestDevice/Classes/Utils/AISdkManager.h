//
//  AISdkManager.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/22.
//

#import <Foundation/Foundation.h>
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"
#import "CommonDefines.h"


NS_ASSUME_NONNULL_BEGIN

@interface AISdkManager : NSObject<TRTCCloudDelegate>
@property (nonatomic, strong) NSMutableDictionary<NSString *, dispatch_block_t> *taskDictionary;
@property (nonatomic, strong) NSMutableArray<NSString *> *aiMessageList;

@property (strong, nonatomic) NSString *lastTaskId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *aiUserId;
@property (assign, nonatomic) Boolean aiSpeaking;
@property (assign, nonatomic) Boolean aiTextEnd;
@property (assign, nonatomic) NSInteger aiVolume;
@property (assign, nonatomic) NSInteger userVolume;

@property (assign, nonatomic) AIStatus aiStatus;


+ (instancetype)sharedInstance;

- (void) addAISpeakDone:(NSString *)taskID
              callback:(void (^)(NSString *taskID))callback
                maxTime:(NSTimeInterval)maxTime;

- (void) triggerAISpeakDoneCallback:(NSString *)taskID;

-(void) setupTRTC;

-(void) interruptAI;
-(void) sendMessageToAI:(NSString *) msg;
-(void) muteLocalAudio;

@end

NS_ASSUME_NONNULL_END
