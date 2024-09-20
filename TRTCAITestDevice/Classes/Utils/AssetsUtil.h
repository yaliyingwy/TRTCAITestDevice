//
//  AssetsUtil.h
//  Pods
//
//  Created by ywen on 2024/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetsUtil : NSObject

+ (UIImage *)imageNamed:(NSString *)imageName;

+ (NSBundle *) aiBundle;

+ (NSString *)localizedWithLanguage:(NSString *)langue Key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
