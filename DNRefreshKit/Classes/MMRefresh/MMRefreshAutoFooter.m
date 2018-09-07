//
//  MMRefreshAutoFooter.m
//  DoNews
//
//  Created by Jamie on 2017/6/6.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshAutoFooter.h"
#import "UIView+JAExt.h"
#import "UIScrollView+JAExt.h"
#import "UIScrollView+MMRefresh.h"
#import "MMRefreshConst.h"

@interface MMRefreshAutoFooter ()

@end

@implementation MMRefreshAutoFooter
#pragma mark - Override
-(void)prepare
{
    [super prepare];
    self.triggerAutomaticallyLoadPercent = 1.0;
    self.automaticallyLoad = YES;
}

-(void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    self.y = self.scrollView.mm_contentHeight - self.ignoredContentInsetBottom;// 设置位置
}


-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    if (self.state != MMRefreshStateNormal || !self.automaticallyLoad || self.y == 0) return;
    
    if (_scrollView.mm_insetTop + _scrollView.mm_contentHeight > _scrollView.height) { // 内容超过一个屏幕
        // 这里的_scrollView.mm_contentH替换掉self.mj_y更为合理
        CGFloat one = _scrollView.mm_offsetY ;
        CGFloat two = _scrollView.mm_contentHeight - _scrollView.height + self.height * self.triggerAutomaticallyLoadPercent + _scrollView.mm_insetBottom - self.height;
        if (one >= two ) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            NSLog(@"\nold  = %@，\nnew  = %@",NSStringFromCGPoint(old),NSStringFromCGPoint(new));
            // 当底部刷新控件完全出现时，才刷新
            [self beginLoading];
        }
    }

}

-(void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    if (self.state != MMRefreshStateNormal) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.mm_insetTop + _scrollView.mm_contentHeight <= _scrollView.height) {  // 不够一个屏幕
            if (_scrollView.mm_offsetY >= - _scrollView.mm_insetTop) { // 向上拽
                [self beginLoading];
            }
        } else { // 超出一个屏幕
            CGFloat one = _scrollView.mm_offsetY ;
            CGFloat two = _scrollView.mm_contentHeight - _scrollView.height + self.height * self.triggerAutomaticallyLoadPercent + _scrollView.mm_insetBottom;
//            CGFloat two =  _scrollView.mm_contentHeight + _scrollView.mm_insetBottom - _scrollView.height;
            if (one >= two ) {
                [self beginLoading];
            }
        }
    }

}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.mm_insetBottom += self.height;
        }
        
        // 设置位置
        self.y = _scrollView.mm_contentHeight - self.ignoredContentInsetBottom;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.mm_insetBottom -= self.height;
        }
    }
}

#pragma mark - Public

#pragma mark - Private

#pragma mark - Getter and Setter

-(void)setState:(MMRefreshState)state
{
    MMRefreshCheckState
    if (state == MMRefreshStateLoading) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    } else if (state == MMRefreshStateNoMoreData || state == MMRefreshStateNormal) {
        if (MMRefreshStateLoading == oldState) {
            if (self.endLoadingCompletionBlock) {
                self.endLoadingCompletionBlock();
            }
        }
    }
}

-(void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = MMRefreshStateNormal;
        
        self.scrollView.mm_insetBottom -= self.height;
    } else if (lastHidden && !hidden) {
        self.scrollView.mm_insetBottom += self.height;
        
        // 设置位置
        self.y = _scrollView.mm_contentHeight - self.ignoredContentInsetBottom;
    }
}
@end
