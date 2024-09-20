//
//  LanguageManager.m
//  Pods
//
//  Created by ywen on 2024/9/12.
//

#import "LanguageManager.h"
#import "AssetsUtil.h"


@implementation LanguageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentLanguage = @"en";
    }
    return self;
}

+ (instancetype)sharedManager {
    static LanguageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull NSString *)localizedStringForKey:(nonnull NSString *)key {
    return [AssetsUtil localizedWithLanguage:_currentLanguage Key:key];
}

-(void)setCurrentLanguage:(NSString *)currentLanguage {
    _originLangCode = currentLanguage;
    NSString *lang = @"en";
    if ([currentLanguage hasPrefix:@"zh"]) {
        lang = @"zh-Hans";
    } else if ([currentLanguage hasPrefix:@"fr"]) {
        lang = @"fr";
    }
    _currentLanguage = lang;
}

@end
