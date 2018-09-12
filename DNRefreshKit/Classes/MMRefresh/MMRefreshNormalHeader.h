//
//  MMRefreshNormalHeader.h
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshStateHeader.h"
#if __has_include( <FLAnimatedImage/FLAnimatedImage.h>)
#import <FLAnimatedImage/FLAnimatedImage.h>
#else
#import "FLAnimatedImage.h"
#endif

@interface MMRefreshNormalHeader : MMRefreshStateHeader

/// 下拉加载的GIF动画
@property (strong, nonatomic) FLAnimatedImageView *arrowView;
/// 菊花的样式
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
/// 替换自带的gif图标
@property (nonatomic, strong) FLAnimatedImage *animationImage;

@end
