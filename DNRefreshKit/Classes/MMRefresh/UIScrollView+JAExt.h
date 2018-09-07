//
//  UIScrollView+JAExt.h
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (JAExt)
    
@property (assign, nonatomic) CGFloat mm_insetTop;
@property (assign, nonatomic) CGFloat mm_insetBottom;
@property (assign, nonatomic) CGFloat mm_insetLeft;
@property (assign, nonatomic) CGFloat mm_insetRight;

@property (assign, nonatomic) CGFloat mm_offsetX;
@property (assign, nonatomic) CGFloat mm_offsetY;

@property (assign, nonatomic) CGFloat mm_contentWidth;
@property (assign, nonatomic) CGFloat mm_contentHeight;
    
@end
