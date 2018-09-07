//
//  MMRefreshNormalHeader.h
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshStateHeader.h"
#import "FLAnimatedImageView.h"

#if __has_include( <FLAnimatedImage/FLAnimatedImage.h>)
#import <FLAnimatedImage/FLAnimatedImage.h>
#else
#import "FLAnimatedImage.h"
#endif

@interface MMRefreshNormalHeader : MMRefreshStateHeader

//@property (weak, nonatomic, readonly) UIImageView *arrowView;
@property (weak, nonatomic) FLAnimatedImageView *arrowView;//下拉加载的GIF动画
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
