//
//  PermissionManager.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/24.
//

#import "PermissionManager.h"


@implementation PermissionManager

//照相机是否可用
+(BOOL)isCameraAvailable:(void (^)(BOOL granted))handler
{
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(granted);
                });

                NSLog(@"granted --- %d currentThread : %@",granted,NSThread.currentThread);
            }];
            NSLog(@"用户尚未授予或拒绝该权限:AVAuthorizationStatusNotDetermined");
        }
            break;
        case AVAuthorizationStatusRestricted:
            handler(NO);
            NSLog(@"不允许用户访问媒体捕获设备:AVAuthorizationStatusRestricted");
            break;
        case AVAuthorizationStatusDenied:
            handler(NO);
            NSLog(@"用户已经明确拒绝了应用访问捕获设备:AVAuthorizationStatusDenied");
            break;
        case AVAuthorizationStatusAuthorized:
            NSLog(@"用户授予应用访问捕获设备的权限:AVAuthorizationStatusAuthorized");
            handler(YES);
            return YES;
            break;
        default:
            break;
    }
    return NO;
}



//麦克风是否可用
+(BOOL)isMicphoneAvailable:(void (^)(BOOL granted))handler
{
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio])
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(granted);
                });

                NSLog(@"granted --- %d currentThread : %@",granted,NSThread.currentThread);
            }];
            NSLog(@"用户尚未授予或拒绝该权限:AVAuthorizationStatusNotDetermined");
        }
            break;
        case AVAuthorizationStatusRestricted:
            handler(NO);
            NSLog(@"不允许用户访问媒体捕获设备:AVAuthorizationStatusRestricted");
            break;
        case AVAuthorizationStatusDenied:
            handler(NO);
            NSLog(@"用户已经明确拒绝了应用访问捕获设备:AVAuthorizationStatusDenied");
            break;
        case AVAuthorizationStatusAuthorized:
            NSLog(@"用户授予应用访问捕获设备的权限:AVAuthorizationStatusAuthorized");
            handler(YES);
            return YES;
            break;
        default:
            break;
    }
    return NO;
}

+ (NSString *)getTestFailureMsg:(AVMediaType)mediaType {
    switch ([AVCaptureDevice authorizationStatusForMediaType:mediaType]) {
        case AVAuthorizationStatusNotDetermined:
            return @"用户尚未授予或拒绝该权限";
            break;
        case AVAuthorizationStatusRestricted:
            return @"不允许用户访问媒体捕获设备";
            break;
        case AVAuthorizationStatusDenied:
            return @"用户已经明确拒绝了应用访问捕获设备";
            break;
        case AVAuthorizationStatusAuthorized:
            return @"";
            break;
        default:
            return @"初始化失败";
            break;
    }
}

@end
