//
//  UIScrollView+JAExt.m
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "UIScrollView+JAExt.h"

@implementation UIScrollView (JAExt)
- (void)setMm_insetTop:(CGFloat)mm_insetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = mm_insetTop;
    self.contentInset = inset;
}

- (CGFloat)mm_insetTop
{
    return self.contentInset.top;
}

- (void)setMm_insetBottom:(CGFloat)mm_insetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = mm_insetBottom;
    self.contentInset = inset;
}

- (CGFloat)mm_insetBottom
{
    return self.contentInset.bottom;
}

- (void)setMm_insetLeft:(CGFloat)mm_insetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = mm_insetLeft;
    self.contentInset = inset;
}

- (CGFloat)mm_insetLeft
{
    return self.contentInset.left;
}

- (void)setMm_insetRight:(CGFloat)mm_insetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = mm_insetRight;
    self.contentInset = inset;
}

- (CGFloat)mm_insetRight
{
    return self.contentInset.right;
}

- (void)setMm_offsetX:(CGFloat)mm_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = mm_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)mm_offsetX
{
    return self.contentOffset.x;
}

- (void)setMm_offsetY:(CGFloat)mm_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = mm_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)mm_offsetY
{
    return self.contentOffset.y;
}

- (void)setMm_contentWidth:(CGFloat)mm_contentWidth
{
    CGSize size = self.contentSize;
    size.width = mm_contentWidth;
    self.contentSize = size;
}

- (CGFloat)mm_contentWidth
{
    return self.contentSize.width;
}

- (void)setMm_contentHeight:(CGFloat)mm_contentHeight
{
    CGSize size = self.contentSize;
    size.height = mm_contentHeight;
    self.contentSize = size;
}

- (CGFloat)mm_contentHeight
{
    return self.contentSize.height;
}

@end
