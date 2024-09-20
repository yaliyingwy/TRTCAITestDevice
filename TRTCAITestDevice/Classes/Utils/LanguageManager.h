//
//  LanguageManager.h
//  Pods
//
//  Created by ywen on 2024/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanguageManager : NSObject

@property (nonatomic, strong) NSString *currentLanguage;
@property (nonatomic, strong) NSString *originLangCode;

+ (instancetype)sharedManager;
- (NSString *)localizedStringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
