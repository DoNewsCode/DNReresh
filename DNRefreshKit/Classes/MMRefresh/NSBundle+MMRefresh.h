//
//  NSBundle+MMRefresh.h
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLAnimatedImage.h"


@interface NSBundle (MMRefresh)
    
+ (instancetype)mm_refreshBundle;
+ (UIImage *)mm_arrowImage;
+ (FLAnimatedImage *)mm_arrowHeaderImage;
+ (FLAnimatedImage *)mm_arrowHeaderImageRefresh;
+ (NSString *)mm_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)mm_localizedStringForKey:(NSString *)key;
    
@end
