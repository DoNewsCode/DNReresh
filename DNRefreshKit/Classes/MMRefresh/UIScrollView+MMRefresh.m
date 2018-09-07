//
//  UIScrollView+MMRefresh.m
//  DoNews
//
//  Created by Jamie on 2017/5/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "UIScrollView+MMRefresh.h"
#import <objc/runtime.h>
#import "MMRefreshHeader.h"
#import "MMRefreshFooter.h"
@implementation NSObject (MJRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end
@implementation UIScrollView (MMRefresh)
#pragma mark - header
static const char MMRefreshHeaderKey = '\0';
- (void)setMm_header:(MMRefreshHeader *)mm_header
{
    if (mm_header != self.mm_header) {
        // 删除旧的，添加新的
        [self.mm_header removeFromSuperview];
        [self insertSubview:mm_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"mm_header"]; // KVO
        objc_setAssociatedObject(self, &MMRefreshHeaderKey,
                                 mm_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"mm_header"]; // KVO
    }
}

- (MMRefreshHeader *)mm_header
{
    return objc_getAssociatedObject(self, &MMRefreshHeaderKey);
}

#pragma mark - footer
static const char MMRefreshFooterKey = '\0';
- (void)setMm_footer:(MMRefreshFooter *)mm_footer
{
    if (mm_footer != self.mm_footer) {
        // 删除旧的，添加新的
        [self.mm_footer removeFromSuperview];
        [self insertSubview:mm_footer atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"mm_footer"]; // KVO
        objc_setAssociatedObject(self, &MMRefreshFooterKey,
                                 mm_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"mm_footer"]; // KVO
    }
}

- (MMRefreshFooter *)mm_footer
{
    return objc_getAssociatedObject(self, &MMRefreshFooterKey);
}

#pragma mark - other
- (NSInteger)mm_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char MMRefreshReloadDataBlockKey = '\0';
- (void)setMm_reloadDataBlock:(void (^)(NSInteger))mm_reloadDataBlock
{
    [self willChangeValueForKey:@"mm_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &MMRefreshReloadDataBlockKey, mm_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"mm_reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))mm_reloadDataBlock
{
    return objc_getAssociatedObject(self, &MMRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.mm_reloadDataBlock ? : self.mm_reloadDataBlock(self.mm_totalDataCount);
}
@end

@implementation UITableView (MMRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mm_reloadData)];
}

- (void)mm_reloadData
{
    [self mm_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (MMRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(mm_reloadData)];
}

- (void)mm_reloadData
{
    [self mm_reloadData];
    
    [self executeReloadDataBlock];
}
@end
