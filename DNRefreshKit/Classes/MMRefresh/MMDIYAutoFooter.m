//
//  MMDIYAutoFooter.m
//  DoNews
//
//  Created by Jamie on 2017/9/26.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMDIYAutoFooter.h"
#import "MMRefreshConst.h"
#import "UIView+JAExt.h"

@interface MMDIYAutoFooter()
    
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UISwitch *s;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
    
@end
@implementation MMDIYAutoFooter

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.height = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // 打酱油的开关
    UISwitch *s = [[UISwitch alloc] init];
    [self addSubview:s];
    self.s = s;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    loading.frame = (CGRect){0.,0.,200.,30.};
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
//    self.s.center = CGPointMake(self.width - 20, self.height - 20);
    
    self.loading.center = CGPointMake(30, self.height * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MMRefreshState)state
{
    MMRefreshCheckState
    
    switch (state) {
        case MMRefreshStateNormal:
            self.label.text = @"赶紧上拉吖(开关是打酱油滴)";
            [self.loading stopAnimating];
//            [self.s setOn:NO animated:YES];
            break;
        case MMRefreshStateLoading:
//            [self.s setOn:YES animated:YES];
            self.label.text = @"加载数据中(开关是打酱油滴)";
            [self.loading startAnimating];
            break;
        case MMRefreshStateNoMoreData:
            self.label.text = @"木有数据了(开关是打酱油滴)";
//            [self.s setOn:NO animated:YES];
            [self.loading stopAnimating];
            break;
        default:
            break;
    }
}



@end
