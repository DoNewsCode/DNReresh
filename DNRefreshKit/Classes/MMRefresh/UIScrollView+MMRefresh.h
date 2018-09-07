//
//  UIScrollView+MMRefresh.h
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMRefreshHeader,MMRefreshFooter;

@interface UIScrollView (MMRefresh)

/** 下拉刷新控件 */
@property (strong, nonatomic) MMRefreshHeader *mm_header;
/** 上拉刷新控件 */
@property (strong, nonatomic) MMRefreshFooter *mm_footer;

#pragma mark - other
- (NSInteger)mm_totalDataCount;
@property (copy, nonatomic) void (^mm_reloadDataBlock)(NSInteger totalDataCount);
    
@end
