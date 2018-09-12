//
//  MMRefreshNormalHeader.m
//  DoNews
//
//  Created by Jamie on 2017/5/31.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshNormalHeader.h"
#import "NSBundle+MMRefresh.h"
#import "UIView+JAExt.h"
#import "MMRefreshConst.h"

@interface MMRefreshNormalHeader ()

@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) FLAnimatedImage *animtionImage;

@end

@implementation MMRefreshNormalHeader

#pragma mark - Override
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
///>修改下拉刷新图片及其 frame
    // 箭头的中心点
    CGFloat arrowCenterX = self.width * 0.5;

    CGFloat arrowCenterY = self.height * 0.5-5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
//        self.arrowView.size = CGSizeMake(70., 40.);
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
}

- (void)setState:(MMRefreshState)state
{
    MMRefreshCheckState
    
    // 根据状态做事情
    if (state == MMRefreshStateNormal) {
        if (oldState == MMRefreshStateLoading) {
//            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:self.style.animationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MMRefreshStateNormal) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
//            [UIView animateWithDuration:self.style.animationDuration animations:^{
//                self.arrowView.transform = CGAffineTransformIdentity;
//            }];
        }
    } else if (state == MMRefreshStatePressing) {
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
//        [UIView animateWithDuration:self.style.animationDuration animations:^{
//            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
//        }];
    } else if (state == MMRefreshStateLoading) {
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
        self.arrowView.hidden = NO;
    }
}

#pragma mark - Public

#pragma mark - Private

#pragma mark - Getter and Setter
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}

- (void)setAnimationImage:(FLAnimatedImage *)animationImage {
    _animtionImage = animationImage;
    if (animationImage) {
        [self.arrowView setAnimatedImage:animationImage];
        self.arrowView.size = CGSizeMake(animationImage.size.width * 0.5, animationImage.size.height * 0.54);
    }
}

///>下拉刷新图片改为 GIF 动图
-(FLAnimatedImageView *)arrowView{

    if (!_arrowView) {
        FLAnimatedImage *image = [NSBundle mm_arrowHeaderImage];
        _arrowView = [FLAnimatedImageView new];
        [_arrowView setAnimatedImage:image];
        [self addSubview:_arrowView];
        [self sendSubviewToBack:_arrowView];
        _arrowView.size = CGSizeMake(image.size.width * 0.5, image.size.height * 0.54);
    }
    return _arrowView;
}
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
//        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

@end
