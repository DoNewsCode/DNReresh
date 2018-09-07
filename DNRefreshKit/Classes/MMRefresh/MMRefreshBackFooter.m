//
//  MMRefreshBackFooter.m
//  DoNews
//
//  Created by Jamie on 2017/6/9.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshBackFooter.h"
#import "MMRefreshComponent.h"
#import "UIScrollView+JAExt.h"
#import "MMRefreshConst.h"
#import "UIView+JAExt.h"
#import "UIScrollView+MMRefresh.h"
@interface MMRefreshBackFooter ()
@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;
@end
@implementation MMRefreshBackFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self scrollViewContentSizeDidChange:nil];
}

#pragma mark - 实现父类的方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 如果正在刷新，直接返回
    if (self.state == MMRefreshStateLoading) return;
    
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.mm_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.height;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == MMRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.height;
        
        if (self.state == MMRefreshStateNormal && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MMRefreshStatePressing;
        } else if (self.state == MMRefreshStatePressing && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MMRefreshStateNormal;
        }
    } else if (self.state == MMRefreshStatePressing) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginLoading];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的高度
    CGFloat contentHeight = self.scrollView.mm_contentHeight - self.ignoredContentInsetBottom + self.scrollView.contentInset.top + self.scrollView.contentInset.bottom - (self.state == MMRefreshStateLoading ? (self.scrollView.contentInset.bottom - self.ignoredContentInsetBottom) : 0);
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredContentInsetBottom;
    // 设置位置和尺寸
    self.y = MAX(contentHeight, scrollHeight);
}

- (void)setState:(MMRefreshState)state
{
    MMRefreshCheckState
    
    // 根据状态来设置属性
    if (state == MMRefreshStateNoMoreData || state == MMRefreshStateNormal) {
        // 刷新完毕
        if (MMRefreshStateLoading == oldState) {
            [UIView animateWithDuration:self.style.animationDuration animations:^{
                self.scrollView.mm_insetBottom -= self.lastBottomDelta;
                
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                
                if (self.endLoadingCompletionBlock) {
                    self.endLoadingCompletionBlock();
                }
            }];
        }
        
        CGFloat deltaH = [self heightForContentBreakView];
        // 刚刷新完毕
        if (MMRefreshStateLoading == oldState && deltaH > 0 && self.scrollView.mm_totalDataCount != self.lastRefreshCount) {
            self.scrollView.mm_offsetY = self.scrollView.mm_offsetY;
        }
    } else if (state == MMRefreshStateLoading) {
        // 记录刷新前的数量
        self.lastRefreshCount = self.scrollView.mm_totalDataCount;
        
        [UIView animateWithDuration:self.style.animationDuration animations:^{
            CGFloat bottom = self.height + self.scrollViewOriginalInset.bottom;
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) { // 如果内容高度小于view的高度
                bottom -= deltaH;
            }
            self.lastBottomDelta = bottom - self.scrollView.mm_insetBottom;
            self.scrollView.mm_insetBottom = bottom;
            self.scrollView.mm_offsetY = [self happenOffsetY] + self.height;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}

- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = MMRefreshStateNormal;
    });
}

- (void)endRefreshingWithNoMoreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = MMRefreshStateNoMoreData;
    });
}
#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

@end
