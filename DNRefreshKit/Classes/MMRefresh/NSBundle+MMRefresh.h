//
//  NSBundle+MMRefresh.h
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include( <FLAnimatedImage/FLAnimatedImage.h>)
#import <FLAnimatedImage/FLAnimatedImage.h>
#else
#import "FLAnimatedImage.h"
#endif

@interface NSBundle (MMRefresh)
    
+ (instancetype)mm_refreshBundle;
+ (UIImage *)mm_arrowImage;
+ (FLAnimatedImage *)mm_arrowHeaderImage;
+ (FLAnimatedImage *)mm_arrowHeaderImageRefresh;
+ (NSString *)mm_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)mm_localizedStringForKey:(NSString *)key;
    
@end
