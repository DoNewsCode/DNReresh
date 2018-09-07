//
//  MMRefreshBackStateFooter.h
//  DoNews
//
//  Created by Jamie on 2017/6/9.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshBackFooter.h"

@interface MMRefreshBackStateFooter : MMRefreshBackFooter


/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MMRefreshState)state;

/** 获取state状态下的title */
- (NSString *)titleForState:(MMRefreshState)state;
@end
