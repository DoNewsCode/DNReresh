//
//  MMRefreshStyle.m
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshStyle.h"

#define UIColorRGB(_red_, _green_, _blue_, _alpha_) [UIColor colorWithRed:(_red_)/255.0 green:(_green_)/255.0 blue:(_blue_)/255.0 alpha:(_alpha_)]

@implementation MMRefreshStyle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _animationDuration = 0.25;
        _refreshFooterHeight = 44.;
        _refreshHeaderHeight = 54.;
        _labelLeftInset = 25.;
        _refreshHeaderBackgroundColor = [UIColor clearColor];
        _refreshFooterBackgroundColor = [UIColor clearColor];
        _refreshBackgroundColor = [UIColor clearColor];
///> 修改 下拉刷新控件 显示的状态文字字体
//        _refreshTextFont = [UIFont boldSystemFontOfSize:14.];
        _refreshTextFont = [UIFont systemFontOfSize:10.];
        _refreshTextColor = UIColorRGB(55., 55., 55., 1.);
    }
    return self;
}
@end
