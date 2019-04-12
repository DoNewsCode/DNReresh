//
//  MMRefrashNewsListFooter.m
//  DoNews
//
//  Created by Jamie on 2017/6/6.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefrashNewsListFooter.h"
#import "UIView+JAExt.h"
#import "MMRefreshConst.h"
@interface MMRefrashNewsListFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation MMRefrashNewsListFooter

#pragma mark - Override
-(void)prepare
{
    [super prepare];
    // 设置控件的高度
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = self.style.refreshTextColor;
    label.font = self.style.refreshTextFont;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}


-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)placeSubviews
{
    [super placeSubviews];
    self.label.frame = CGRectMake(0, 0, self.bounds.size.width, 30);
    // 箭头的中心点
    CGFloat arrowCenterX = self.width * 0.5;
    if (!self.label.hidden) {
        arrowCenterX -= 20 + self.label.textWith * 0.5;
    }
    CGFloat arrowCenterY = self.height * 0.3;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    self.loading.center = arrowCenter;
    
}
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
//    NSLog(@"监听scrollView的contentOffset改变");
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
//     NSLog(@"监听scrollView的contentSize改变");
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
//     NSLog(@"监听scrollView的拖拽状态改变");
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MMRefreshState)state
{
    MMRefreshCheckState;
    
    switch (state) {
        case MMRefreshStateNormal:
            self.label.text = @"上拉加载更多数据";//上拉加载更多

            [self.loading stopAnimating];
            break;
        case MMRefreshStatePressing:
            self.label.text = @"即将开始加载";//上拉加载更多
                        [self.loading stopAnimating];
            break;
        case MMRefreshStateLoading:

            self.label.text = @"正在加载更多数据";
            [self.loading startAnimating];
            break;
        case MMRefreshStateNoMoreData:
            self.label.text = @"没有更多数据了";
            [self.loading stopAnimating];
        case MMRefreshStateNoText:
            self.label.text = @"";
            [self.loading stopAnimating];
            
            break;
        default:
            break;
    }
  
}

#pragma mark - Public

#pragma mark - Private

#pragma mark - Getter and Setter
@end
