//
//  MMRefreshHeader.m
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshHeader.h"
#import "UIView+JAExt.h"
#import "UIScrollView+MMRefresh.h"
#import "MMRefreshConst.h"
#import "UIScrollView+JAExt.h"
@interface MMRefreshHeader ()
@property (assign, nonatomic) CGFloat insetTopDelta;
@end
@implementation MMRefreshHeader

#pragma mark - Override
-(void)prepare
{
    [super prepare];
    
    self.height = self.style.refreshHeaderHeight;
    self.lastUpdatedTimeKey = MMRefreshHeaderLastUpdatedTimeKey;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.y = - self.height - self.ignoredContentInsetTop;
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    // 在刷新的refreshing状态
    if (self.state == MMRefreshStateLoading) {
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.mm_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mm_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.height + _scrollViewOriginalInset.top ? self.height + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mm_insetTop = insetT;
        
        self.insetTopDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mm_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.height;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.height;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MMRefreshStateNormal && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MMRefreshStatePressing;
        } else if (self.state == MMRefreshStatePressing && offsetY >= normal2pullingOffsetY) {
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
#pragma mark - Public
/** 创建header */
+ (instancetype)refreshHeaderWithStyle:(nullable MMRefreshStyle *)style loadingBlock:(MMRefreshComponentEnterLoadingBlock)loadingBlock
{
    MMRefreshHeader *component = [[self alloc] initWithMMRefreshStyle:style];
    component.loadingBlock = loadingBlock;
    return component;
}

/** 创建header */
+ (instancetype)refreshHeaderWithStyle:(nullable MMRefreshStyle *)style loadingTarget:(id)target loadingAction:(SEL)action
{
    MMRefreshHeader *component = [[self alloc] initWithMMRefreshStyle:style];
    [component setLoadingTarget:target loadingAction:action];
    return component;
}

-(void)endLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = MMRefreshStateNormal;
    });
}

-(NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}

#pragma mark - Private

#pragma mark - Getter and Setter
-(void)setState:(MMRefreshState)state
{
    MMRefreshCheckState
    // 根据状态做事情
    if (state == MMRefreshStateNormal) {
        if (oldState != MMRefreshStateLoading) return;
        
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 恢复inset和offset
        [UIView animateWithDuration:self.style.animationDuration animations:^{
            self.scrollView.mm_insetTop += self.insetTopDelta;
            
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
            if (self.endLoadingCompletionBlock) {
                self.endLoadingCompletionBlock();
            }
        }];
    } else if (state == MMRefreshStateLoading) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:self.style.animationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.height;
                // 增加滚动区域top
                self.scrollView.mm_insetTop = top;
                // 设置滚动位置
                [self.scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        });
    }else if (state == MMRefreshStateWillEndLoad){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (oldState != MMRefreshStateLoading) return;
            
            // 保存刷新时间
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 恢复inset和offset
            [UIView animateWithDuration:self.style.animationDuration animations:^{
                self.scrollView.mm_insetTop += self.insetTopDelta;
                
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                
                if (self.endLoadingCompletionBlock) {
                    self.endLoadingCompletionBlock();
                }
            }];

            
        });
    }
}

@end
