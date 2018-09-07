//
//  MMRefreshHeader.h
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshComponent.h"
@interface MMRefreshHeader : MMRefreshComponent
/** 创建header */
+ (instancetype _Nullable )refreshHeaderWithStyle:(nullable MMRefreshStyle *)style loadingBlock:(MMRefreshComponentEnterLoadingBlock _Nullable )loadingBlock;
/** 创建header */
+ (instancetype _Nullable
   )refreshHeaderWithStyle:(nullable MMRefreshStyle *)style loadingTarget:(id _Nullable )target loadingAction:(SEL _Nullable )action;
/** 
 上一次下拉刷新成功的时间
 */
@property (strong, nonatomic, readonly) NSDate * _Nullable lastUpdatedTime;

/** 这个key用来存储上一次下拉刷新成功的时间 */
@property (copy, nonatomic) NSString * _Nullable lastUpdatedTimeKey;
/** 
 忽略contentInset顶部距离的值
 */
@property (assign, nonatomic) CGFloat ignoredContentInsetTop;
@end
