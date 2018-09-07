//
//  MMRefreshBackStateFooter.m
//  DoNews
//
//  Created by Jamie on 2017/6/9.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshBackStateFooter.h"
#import "NSBundle+MMRefresh.h"
#import "MMRefreshConst.h"
#import "MMRefreshComponent.h"
@interface MMRefreshBackStateFooter ()
{
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;


@end
@implementation MMRefreshBackStateFooter

#pragma mark - Override
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = self.style.labelLeftInset;
    
    // 初始化文字
    [self setTitle:[NSBundle mm_localizedStringForKey:MMRefreshBackFooterIdleText] forState:MMRefreshStateNormal];
    [self setTitle:[NSBundle mm_localizedStringForKey:MMRefreshBackFooterPullingText] forState:MMRefreshStatePressing];
    [self setTitle:[NSBundle mm_localizedStringForKey:MMRefreshBackFooterRefreshingText] forState:MMRefreshStateLoading];
    [self setTitle:[NSBundle mm_localizedStringForKey:MMRefreshBackFooterNoMoreDataText] forState:MMRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(MMRefreshState)state
{
    MMRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
}

#pragma mark - Public
- (void)setTitle:(NSString *)title forState:(MMRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (NSString *)titleForState:(MMRefreshState)state {
    return self.stateTitles[@(state)];
}

#pragma mark - Private

#pragma mark - Getter and Setter
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel mmLabelWithStyle:self.style]];
    }
    return _stateLabel;
}
@end
