//
//  AssetsUtil.m
//  Pods
//
//  Created by ywen on 2024/9/11.
//

#import "AssetsUtil.h"

@implementation AssetsUtil

+(NSBundle *)aiBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [bundle URLForResource:@"TRTCAITestDevice" withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    return resourceBundle;
}

+ (UIImage *)imageNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName inBundle:[self aiBundle] compatibleWithTraitCollection:nil];
    return image;
}

+ (NSString *)localizedWithLanguage:(NSString *)langue Key:(NSString *)key
{

    NSBundle *bundle = [self aiBundle];

    NSString *path = [bundle pathForResource:langue ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    NSString *value = [languageBundle localizedStringForKey:key value:key table:@"AITestDeviceLocalizable"];
    if (value) {
        return value;
    }
    return key;
}

@end
