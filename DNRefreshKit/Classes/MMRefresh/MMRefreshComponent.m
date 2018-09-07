//
//  MMRefreshComponent.m
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshComponent.h"
#import "MMRefreshStyle.h"
#import "MMRefreshConst.h"
#import "UIView+JAExt.h"
@interface MMRefreshComponent ()
@property (strong, nonatomic) UIPanGestureRecognizer *panGesRe;
@end
@implementation MMRefreshComponent

#pragma mark - Override

-(void)layoutSubviews
{
    [self placeSubviews];
    [super layoutSubviews];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.width = newSuperview.width;
        // 设置位置
        self.x = 0;
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        // 添加监听
        [self addObservers];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.state == MMRefreshStateWillLoad) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = MMRefreshStateLoading;
    }
}
#pragma mark - Public

- (instancetype)initWithMMRefreshStyle:(nullable MMRefreshStyle *)style
{
    self = [super init];
    if (self) {
        self.style = style == nil ? [MMRefreshStyle new] : style;
        [self prepare];
        // 默认是普通状态
        self.state = MMRefreshStateNormal;
    }
    return self;
}
-(void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = _style.refreshBackgroundColor;
}

-(void)placeSubviews{}


#pragma mark 设置回调对象和回调方法
- (void)setLoadingTarget:(id)target loadingAction:(SEL)action
{
    self.loadingTarget = target;
    self.loadingAction = action;
}

- (void)setState:(MMRefreshState)state
{
    _state = state;
    
    // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

#pragma mark 进入刷新状态
- (void)beginLoading
{
    [UIView animateWithDuration:self.style.animationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = MMRefreshStateLoading;
    } else {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.state != MMRefreshStateLoading) {
            self.state = MMRefreshStateWillLoad;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}

- (void)beginLoadingWithCompletionBlock:(void (^)())completionBlock
{
    self.beginLoadingCompletionBlock = completionBlock;
    
    [self beginLoading];
}

#pragma mark 结束刷新状态
- (void)endLoading
{
    self.state = MMRefreshStateNormal;
//    self.state = MMRefreshStateWillEndLoad;
}

- (void)endLoadingWithCompletionBlock:(void (^)())completionBlock
{
    self.endLoadingCompletionBlock = completionBlock;
    
    [self endLoading];
}

#pragma mark 是否正在刷新
- (BOOL)isLoading
{
    return self.state == MMRefreshStateLoading || self.state == MMRefreshStateWillLoad;
}

#pragma mark 自动切换透明度
- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha
{
    self.automaticallyChangeAlpha = autoChangeAlpha;
}

- (BOOL)isAutoChangeAlpha
{
    return self.isAutomaticallyChangeAlpha;
}

- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    
    if (self.isLoading) return;
    
    if (automaticallyChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}


#pragma mark 根据拖拽进度设置透明度
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    _pullingPercent = pullingPercent;
    
    if (self.isLoading) return;
    
    if (self.isAutomaticallyChangeAlpha) {
        self.alpha = pullingPercent;
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}

#pragma mark - Private
#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MMRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:MMRefreshKeyPathContentSize options:options context:nil];
    self.panGesRe = self.scrollView.panGestureRecognizer;
    [self.panGesRe addObserver:self forKeyPath:MMRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:MMRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:MMRefreshKeyPathContentSize];;
    [self.panGesRe removeObserver:self forKeyPath:MMRefreshKeyPathPanState];
    self.panGesRe = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:MMRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:MMRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:MMRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}
- (void)executeRefreshingCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.loadingBlock) {
            self.loadingBlock();
        }
        if ([self.loadingTarget respondsToSelector:self.loadingAction]) {
            MMRefreshMsgSend(MMRefreshMsgTarget(self.loadingTarget), self.loadingAction, self);
        }
        if (self.beginLoadingCompletionBlock) {
            self.beginLoadingCompletionBlock();
        }
    });
}
#pragma mark - Lazy loading

@end

@implementation UILabel(MMRefresh)
+ (instancetype)mmLabelWithStyle:(nullable MMRefreshStyle *)style
{
    UILabel *label = [[self alloc] init];
    if (style != nil) {
        label.font = style.refreshTextFont;
        label.textColor = style.refreshTextColor;
    }
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
- (CGFloat)textWith
{
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
        stringWidth =[self.text
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:self.font}
                      context:nil].size.width;
    }
     return stringWidth;
}
@end
