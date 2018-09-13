//
//  UIScrollView+Refresh.h
//  TGBus
//
//  Created by donews on 2018/8/9.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRefresh.h"

typedef NS_ENUM(NSUInteger,MMRereshGifType) {
    MMRereshGifTypeDefault,  // 自动的gif动画
    MMRereshGifTypeFrameAnimation // 帧动画
};

@interface UIScrollView (Refresh)

- (void)tg_headerRefreshExecutingBlock:(void(^)(void))executingBlock;
- (void)tg_footerRefreshExecutingBlock:(void(^)(void))executingBlock;
/// isChangeAlpha 下拉时是否改变Alpha 默认为NO
- (void)tg_headerRefreshExecutingBlock:(void(^)(void))executingBlock gifType:(MMRereshGifType)gifType isChangeAlpha:(BOOL)isChangeAlpha;
- (void)tg_headerBeginRefresh;
- (void)tg_headerEndRefresh;
- (void)tg_footerEndRefresh;
/// 是否要隐藏footer刷新
- (void)tg_isHiddenFooter:(BOOL)isHidden;

@end
