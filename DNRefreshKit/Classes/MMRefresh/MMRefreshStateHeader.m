//
//  MMRefreshStateHeader.m
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshStateHeader.h"
#import "MMRefreshConst.h"
#import "UIView+JAExt.h"
#import "NSBundle+MMRefresh.h"
@interface MMRefreshStateHeader ()
{
    /** 显示上一次刷新时间的label */
    __unsafe_unretained UILabel *_lastUpdatedTimeLabel;
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@end

@implementation MMRefreshStateHeader

#pragma mark - Override
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = self.style.labelLeftInset;
    
    // 初始化文字
    [self setTitle:[NSBundle mm_localizedStringForKey:MMRefreshHeaderIdleText] forState:MMRefreshStateNormal];
    [self setTitle:[NSBundle mm_localizedStringForKey:MMRefreshHeaderPullingText] forState:MMRefreshStatePressing];
    [self setTitle:[NSBundle mm_localizedStringForKey:MMRefreshHeaderRefreshingText] forState:MMRefreshStateLoading];
}
- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    
    if (self.lastUpdatedTimeLabel.hidden) {
///>下拉刷新状态文字 frame
        // 状态
//        if (noConstrainsOnStatusLabel) self.stateLabel.frame = self.bounds;
        if (noConstrainsOnStatusLabel) self.stateLabel.frame = CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
        
    } else {
        CGFloat stateLabelH = self.height * 0.5;
        // 状态
        if (noConstrainsOnStatusLabel) {
            self.stateLabel.x = 0;
            self.stateLabel.y = 0;
            self.stateLabel.width = self.width;
            self.stateLabel.height = stateLabelH;
        }
        
        // 更新时间
        if (self.lastUpdatedTimeLabel.constraints.count == 0) {
            self.lastUpdatedTimeLabel.x = 0;
            self.lastUpdatedTimeLabel.y = stateLabelH;
            self.lastUpdatedTimeLabel.width = self.width;
            self.lastUpdatedTimeLabel.height = self.height - self.lastUpdatedTimeLabel.y;
        }
    }
}

- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    // 如果label隐藏了，就不用再处理
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [self currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        BOOL isToday = NO;
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @" HH:mm";
            isToday = YES;
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@%@",
                                          [NSBundle mm_localizedStringForKey:MMRefreshHeaderLastTimeText],
                                          isToday ? [NSBundle mm_localizedStringForKey:MMRefreshHeaderDateTodayText] : @"",
                                          time];
    } else {
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",
                                          [NSBundle mm_localizedStringForKey:MMRefreshHeaderLastTimeText],
                                          [NSBundle mm_localizedStringForKey:MMRefreshHeaderNoneLastDateText]];
    }
}
#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

#pragma mark - Public
- (void)setTitle:(NSString *)title forState:(MMRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}
#pragma mark - Private

#pragma mark - Getter and Setter

- (void)setState:(MMRefreshState)state
{
    MMRefreshCheckState
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 重新设置key（重新显示时间）
    self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
}
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

- (UILabel *)lastUpdatedTimeLabel
{
    if (!_lastUpdatedTimeLabel) {
        [self addSubview:_lastUpdatedTimeLabel = [UILabel mmLabelWithStyle:self.style]];
    }
    return _lastUpdatedTimeLabel;
}
@end
