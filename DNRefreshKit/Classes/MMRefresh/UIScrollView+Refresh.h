//
//  UIScrollView+Refresh.h
//  TGBus
//
//  Created by donews on 2018/8/9.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRefresh.h"

@interface UIScrollView (Refresh)

- (void)tg_headerRefreshExecutingBlock:(void(^)(void))executingBlock;
- (void)tg_footerRefreshExecutingBlock:(void(^)(void))executingBlock;
- (void)tg_headerBeginRefresh;
- (void)tg_headerEndRefresh;
- (void)tg_footerEndRefresh;
/// 是否要隐藏footer刷新
- (void)tg_isHiddenFooter:(BOOL)isHidden;

@end
