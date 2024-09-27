//
//  AITaskProtocol.h
//  TRTCAITestDevice-TRTCAITestDevice
//
//  Created by ywen on 2024/9/14.
//

#import <Foundation/Foundation.h>
#import "CommonDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AITaskProtocol <NSObject>

@required
- (void) performAITask:(AITaskType) task params:(NSDictionary *)params
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

@optional
- (void) reportResult:(AIDeviceDetectType) type result:(AIDeviceDetectResult) result duration:(int) duration extraInfo:(id) extraInfo;
@optional
- (void) autoSkip:(AIDeviceDetectType) type;

@optional
-(void) onDetectPermission:(AIDeviceDetectType) type hasPermission:(Boolean) hasPermission;

@end

NS_ASSUME_NONNULL_END
