//
//  MMRefreshFooter.h
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshComponent.h"
@interface MMRefreshFooter : MMRefreshComponent
/** 创建footer */
+ (instancetype _Nullable )refreshFooterWithStyle:(nullable MMRefreshStyle *)style loadingBlock:(MMRefreshComponentEnterLoadingBlock _Nullable )loadingBlock;
/** 创建footer */
+ (instancetype _Nullable )refreshFooterWithStyle:(nullable MMRefreshStyle *)style loadingTarget:(id _Nullable )target loadingAction:(SEL _Nullable )action;

/** 提示没有更多的数据 */
-(void)endLoadingWithNoMoreData;

/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 忽略多少scrollView的contentInset的bottom */
@property (assign, nonatomic) CGFloat ignoredContentInsetBottom;

/** 自动根据有无数据来显示和隐藏（有数据就显示，没有数据隐藏。默认是NO） */
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden;
@end
