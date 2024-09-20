//
//  UIColor+Util.h
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Util)

+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(float)alpha;

@end

NS_ASSUME_NONNULL_END
