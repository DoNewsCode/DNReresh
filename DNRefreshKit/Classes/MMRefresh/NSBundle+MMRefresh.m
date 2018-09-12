//
//  NSBundle+MMRefresh.m
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "NSBundle+MMRefresh.h"
#import "MMRefreshComponent.h"

@implementation NSBundle (MMRefresh)
+ (instancetype)mm_refreshBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MMRefreshComponent class]] pathForResource:@"DNRefreshKit" ofType:@"bundle"]];
    }
    return refreshBundle;
}

//原先的 现在仅用于上拉加载
+ (UIImage *)mm_arrowImage
{
    static UIImage *arrowImage = nil;
    if (arrowImage == nil) {
        arrowImage = [[UIImage imageWithContentsOfFile:[[self mm_refreshBundle] pathForResource:@"arrow" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return arrowImage;
}

+ (FLAnimatedImage *)mm_arrowHeaderImageRefresh
{
    FLAnimatedImage *arrowImage = nil;
    if (arrowImage == nil) {
        NSString *imgPath = [[self mm_refreshBundle] pathForResource:@"loading" ofType:@"gif"];
        NSData *imgdata = [NSData dataWithContentsOfFile:imgPath];
        arrowImage = [FLAnimatedImage animatedImageWithGIFData:imgdata];
    }
    return arrowImage;
}
//添加的 下拉刷新动图
+ (FLAnimatedImage *)mm_arrowHeaderImage
{
   FLAnimatedImage *arrowImage = nil;
    if (arrowImage == nil) {
        NSString *imgPath = [[self mm_refreshBundle] pathForResource:@"loading" ofType:@"gif"];
        NSData *imgdata = [NSData dataWithContentsOfFile:imgPath];
        arrowImage = [FLAnimatedImage animatedImageWithGIFData:imgdata];
    }
    return arrowImage;
}

+ (NSString *)mm_localizedStringForKey:(NSString *)key
{
    return [self mm_localizedStringForKey:key value:nil];
}

+ (NSString *)mm_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从MMRefresh.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle mm_refreshBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
