//
//  UIColor+Util.m
//  Pods
//
//  Created by ywen on 2024/9/13.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

//十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *colorStr = color ;
    if (color.length == 4) {
        NSString *r = [color substringWithRange:NSMakeRange(1, 1)];
        NSString *g = [color substringWithRange:NSMakeRange(2, 1)];
        NSString *b = [color substringWithRange:NSMakeRange(3, 1)];
        colorStr = [NSString stringWithFormat:@"#%@%@%@%@%@%@",r,r,g,g,b,b];
    }
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }

    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];

    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;

    //R、G、B
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(float)alpha;
{
    UIColor *rcolor = [self colorWithHexString:color];
    return [rcolor colorWithAlphaComponent:alpha];
}

@end
