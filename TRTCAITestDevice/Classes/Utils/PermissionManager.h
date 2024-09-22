//
//  PermissionManager.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermissionManager : NSObject

//照相机是否可用
+(BOOL)isCameraAvailable:(void (^)(BOOL granted))handler;
//麦克风是否可用
+(BOOL)isMicphoneAvailable:(void (^)(BOOL granted))handler;

@end

NS_ASSUME_NONNULL_END
