//
//  MMRefreshNormalBackFooter.h
//  DoNews
//
//  Created by Jamie on 2017/6/9.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshBackStateFooter.h"

@interface MMRefreshNormalBackFooter : MMRefreshBackStateFooter
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
