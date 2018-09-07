//
//  MMRefreshComponent.h
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRefreshStyle.h"
/** 加载控件的状态 */
typedef NS_ENUM(NSInteger, MMRefreshState) {
    /** 普通等待状态 */
    MMRefreshStateNormal = 1,
    /** 松开即可进入加载状态 */
    MMRefreshStatePressing,
    /** 正在加载状态 */
    MMRefreshStateLoading,
    /** 即将要进入加载状态 */
    MMRefreshStateWillLoad,
    /** 即将要结束加载状态 */
    MMRefreshStateWillEndLoad,
    /** 没有更多数据状态 */
    MMRefreshStateNoMoreData,
    /** 无文字状态 */
    MMRefreshStateNoText
};
/** 进入刷新状态的回调 */
typedef void (^MMRefreshComponentEnterLoadingBlock)(void);
/** 开始刷新后的回调(进入刷新状态后的回调) */
typedef void (^MMRefreshComponentBeginLoadingCompletionBlock)(void);
/** 结束刷新后的回调 */
typedef void (^MMRefreshComponentEndLoadingCompletionBlock)(void);

/** 刷新控件的基类 */
@interface MMRefreshComponent : UIView
{
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
    /** 父控件 */
    __weak UIScrollView *_scrollView;
}
#pragma mark - LoadCallback
/** 正在加载的回调 */
@property (nonatomic, copy) MMRefreshComponentEnterLoadingBlock loadingBlock;
/** 设置回调对象和回调方法 */
- (void)setLoadingTarget:(id)target loadingAction:(SEL)action;
/** 回调对象 */
@property (weak, nonatomic) id loadingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL loadingAction;
/** 触发回调（交给子类去调用） */
- (void)executeRefreshingCallback;

#pragma mark - TypeControll
/** 进入刷新状态 */
- (void)beginLoading;
- (void)beginLoadingWithCompletionBlock:(void (^)())completionBlock;
/** 开始加载后的回调(进入刷新状态后的回调) */
@property (copy, nonatomic) MMRefreshComponentBeginLoadingCompletionBlock beginLoadingCompletionBlock;
/** 结束加载的回调 */
@property (copy, nonatomic) MMRefreshComponentEndLoadingCompletionBlock endLoadingCompletionBlock;
/** 结束刷新状态 */
- (void)endLoading;
- (void)endLoadingWithCompletionBlock:(void (^)())completionBlock;
/** 是否正在加载 */
- (BOOL)isLoading;
/** 加载状态 一般交给子类内部实现 */
@property (assign, nonatomic) MMRefreshState state;
/** 控件的各类样式 */
@property (nonatomic, strong) MMRefreshStyle *style;

#pragma mark - childAccess
/** 记录scrollView刚开始的inset */
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
/** 父控件 */
@property (weak, nonatomic, readonly) UIScrollView *scrollView;
- (instancetype)initWithMMRefreshStyle:(nullable MMRefreshStyle *)style;
#pragma mark - child
/** 初始化 */
- (void)prepare NS_REQUIRES_SUPER;
/** 摆放子控件frame */
- (void)placeSubviews NS_REQUIRES_SUPER;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *_Nonnull)change NS_REQUIRES_SUPER;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *_Nonnull)change NS_REQUIRES_SUPER;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *_Nonnull)change NS_REQUIRES_SUPER;


#pragma mark - Other
/** 拉拽的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;
/** 根据拖拽比例自动切换透明度 */
@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用automaticallyChangeAlpha属性");
/** 根据拖拽比例自动切换透明度 */
@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end

@interface UILabel(MMRefresh)
+ (instancetype _Nonnull )mmLabelWithStyle:(nullable MMRefreshStyle *)style;
- (CGFloat)textWith;
@end
