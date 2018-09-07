//
//  UIScrollView+Refresh.m
//  TGBus
//
//  Created by donews on 2018/8/9.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

static char __headerKey,__footerKey;

@interface UIScrollView ()

@property (nonatomic, strong) MMRefreshNormalHeader *header;
@property (nonatomic, strong) MMRefrashNewsListFooter *footer;

@end

@implementation UIScrollView (Refresh)

- (void)tg_headerRefreshExecutingBlock:(void (^)(void))executingBlock {
    
    MMRefreshStyle *headerStyle = [MMRefreshStyle new];
    MMRefreshNormalHeader *header = [MMRefreshNormalHeader refreshHeaderWithStyle:headerStyle loadingBlock:^{
        if (executingBlock) {
            executingBlock();
        }
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间
    header.stateLabel.hidden = YES;
    self.mm_header =  header;
    self.header = header;
}

- (void)tg_footerRefreshExecutingBlock:(void(^)(void))executingBlock {
    
    MMRefrashNewsListFooter *footer = [MMRefrashNewsListFooter refreshFooterWithStyle:nil loadingBlock:^{
        if (executingBlock) {
            executingBlock();
        }
    }];
    self.mm_footer = footer;
    self.mm_footer.hidden = YES;
    self.footer = footer;
}

- (void)tg_headerBeginRefresh {
    [self.header beginLoading];
}

- (void)tg_headerEndRefresh {
    [self.header endLoading];
}

- (void)tg_footerEndRefresh {
    [self.footer endLoading];
}

- (void)tg_isHiddenFooter:(BOOL)isHidden {
    self.footer.hidden = isHidden;
}

#pragma mark - Getters & Setters
- (void)setHeader:(MMRefreshNormalHeader *)header {
    objc_setAssociatedObject(self, &__headerKey, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MMRefreshNormalHeader *)header {
    return objc_getAssociatedObject(self, &__headerKey);
}

- (void)setFooter:(MMRefrashNewsListFooter *)footer {
    objc_setAssociatedObject(self, &__footerKey, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MMRefrashNewsListFooter *)footer {
    return objc_getAssociatedObject(self, &__footerKey);
}


@end
