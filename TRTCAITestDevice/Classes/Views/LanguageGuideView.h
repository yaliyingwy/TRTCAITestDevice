//
//  LanguageGuideView.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import "AIGuideView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LanguageGuideView : AIGuideView

@property (nonatomic, strong) NSArray<NSDictionary *> *languageOptions;
@property (nonatomic, copy) void (^selectionHandler)(NSDictionary *selectedLanguage);

@end

NS_ASSUME_NONNULL_END
