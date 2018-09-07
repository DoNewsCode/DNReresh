//
//  MMRefreshConst.h
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>


// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define MJRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define MJRefreshLog(...)
#endif

// 运行时objc_msgSend
#define MMRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define MMRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define MJRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define MJRefreshLabelTextColor MJRefreshColor(90, 90, 90)

// 字体大小
#define MJRefreshLabelFont [UIFont boldSystemFontOfSize:14]

UIKIT_EXTERN NSString *const MMRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const MMRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const MMRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const MMRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const MMRefreshHeaderLastUpdatedTimeKey;
//
UIKIT_EXTERN NSString *const MMRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const MMRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const MMRefreshHeaderRefreshingText;
//
UIKIT_EXTERN NSString *const MMRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const MMRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const MMRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const MMRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const MMRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const MMRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const MMRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const MMRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const MMRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const MMRefreshHeaderNoneLastDateText;

// 状态检查
#define MMRefreshCheckState \
MMRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
