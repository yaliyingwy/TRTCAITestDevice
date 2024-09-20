//
//  AIDetectProtocol.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//

#import <Foundation/Foundation.h>
#import "CommonDefines.h"
NS_ASSUME_NONNULL_BEGIN



@protocol AIDetectProtocol <NSObject>

@required
-(void) onDetectDone:(AIDetectPage) page;
@required
-(void) onDetectResult:(AIDeviceDetectType) type result:(AIDeviceDetectResult) result;

@optional
-(void) onDetectRetry:(AIDetectPage) page;

@end

NS_ASSUME_NONNULL_END
