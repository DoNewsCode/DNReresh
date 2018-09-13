//
//  MMRefreshGifHeader.h
//  DNRefreshKit
//
//  Created by donews on 2018/9/13.
//

#import "MMRefreshStateHeader.h"

@interface MMRefreshGifHeader : MMRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MMRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MMRefreshState)state;

@end
