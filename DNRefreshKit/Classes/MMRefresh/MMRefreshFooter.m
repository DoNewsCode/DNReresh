 
//
//  MMRefreshFooter.m
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshFooter.h"

#import "UIView+JAExt.h"
#import "UIScrollView+MMRefresh.h"
#import "MMRefreshConst.h"

@interface MMRefreshFooter ()

@end

@implementation MMRefreshFooter


#pragma mark - Override
-(void)prepare
{
    [super prepare];
    self.height = self.style.refreshFooterHeight;
    self.automaticallyHidden = NO;//自动隐藏默认关闭
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        // 监听scrollView数据的变化
        if ([self.scrollView isKindOfClass:[UITableView class]] || [self.scrollView isKindOfClass:[UICollectionView class]]) {
            [self.scrollView setMm_reloadDataBlock:^(NSInteger totalDataCount) {
                if (self.isAutomaticallyHidden) {
                    self.hidden = (totalDataCount == 0);
                }
            }];
        }
    }
}

#pragma mark - Public
/** 创建footer */
+ (instancetype _Nullable )refreshFooterWithStyle:(nullable MMRefreshStyle *)style loadingBlock:(MMRefreshComponentEnterLoadingBlock _Nullable )loadingBlock
{
    MMRefreshFooter *component = [[self alloc] initWithMMRefreshStyle:style];
    component.loadingBlock = loadingBlock;
    return component;
}
/** 创建footer */
+ (instancetype _Nullable )refreshFooterWithStyle:(nullable MMRefreshStyle *)style loadingTarget:(id _Nullable )target loadingAction:(SEL _Nullable )action
{
    MMRefreshFooter *component = [[self alloc] initWithMMRefreshStyle:style];
    [component setLoadingTarget:target loadingAction:action];
    return component;
}

-(void)endLoadingWithNoMoreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = MMRefreshStateNoMoreData;

    });
}

-(void)resetNoMoreData
{
    self.state = MMRefreshStateNormal;
}

#pragma mark - Private

#pragma mark - Getter and Setter
@end
