//
//  MMRefreshStyle.h
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMRefreshStyle : NSObject

/**
 刷新文字距左边栏的距离  默认 25.
 */
@property (nonatomic, assign) CGFloat labelLeftInset;

/**
 刷新视图高度  默认 54.
 */
@property (nonatomic, assign) CGFloat refreshHeaderHeight;

/**
 加载视图高度  默认 44.
 */
@property (nonatomic, assign) CGFloat refreshFooterHeight;

/**
 动画效果持续时间  默认 0.25s
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 刷新视图背景颜色 默认 [UIColor clearColor]
 */
@property (nonatomic, strong) UIColor *refreshHeaderBackgroundColor;

/**
 加载视图背景颜色 默认 [UIColor clearColor]
 */
@property (nonatomic, strong) UIColor *refreshFooterBackgroundColor;

/**
 视图背景颜色 默认 [UIColor clearColor]
 */
@property (nonatomic, strong) UIColor *refreshBackgroundColor;


/**
 刷新状态文字字体 默认 [UIFont boldSystemFontOfSize:14.]
 */
@property (nonatomic, strong) UIFont *refreshTextFont;

/**
 刷新状态文字字体 默认 rgb (55.,55.,55.,1.)
 */
@property (nonatomic, strong) UIColor *refreshTextColor;
@end
