//
//  MMRefreshNormalBackFooter.m
//  DoNews
//
//  Created by Jamie on 2017/6/9.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshNormalBackFooter.h"
#import "MMRefreshConst.h"
#import "NSBundle+MMRefresh.h"
#import "MMRefreshComponent.h"
#import "UIView+JAExt.h"
#import "UIScrollView+JAExt.h"
@interface MMRefreshNormalBackFooter()
{
    __unsafe_unretained UIImageView *_arrowView;
}
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end
@implementation MMRefreshNormalBackFooter
#pragma mark - Override
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.width * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= self.labelLeftInset + self.stateLabel.textWith * 0.5;
    }
    CGFloat arrowCenterY = self.height * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    
    self.arrowView.tintColor = self.stateLabel.textColor;
}
#pragma mark - Public

#pragma mark - Private

#pragma mark - Getter and Setter
- (void)setState:(MMRefreshState)state
{
    MMRefreshCheckState
    
    // 根据状态做事情
    if (state == MMRefreshStateNormal) {
        if (oldState == MMRefreshStateLoading) {
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            [UIView animateWithDuration:self.style.animationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                
                self.arrowView.hidden = YES;//
            }];
        } else {
            self.arrowView.hidden = YES;//
            [self.loadingView stopAnimating];
            [UIView animateWithDuration:self.style.animationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    } else if (state == MMRefreshStatePressing) {
        self.arrowView.hidden = YES;//
        [self.loadingView stopAnimating];
        [UIView animateWithDuration:self.style.animationDuration animations:^{
            self.arrowView.transform = CGAffineTransformIdentity;
        }];
    } else if (state == MMRefreshStateLoading) {
        self.arrowView.hidden = YES;
        [self.loadingView startAnimating];
    } else if (state == MMRefreshStateNormal) {
        self.arrowView.hidden = YES;
        [self.loadingView stopAnimating];
    }
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[NSBundle mm_arrowImage]];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}


- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
@end
