//
//  MMRefreshAutoFooterComponent.h
//  DoNews
//
//  Created by Jamie on 2017/9/26.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "MMRefreshFooter.h"

@interface MMRefreshAutoFooterComponent : MMRefreshFooter
/** 是否自动刷新(默认为YES) */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;
/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
@end
