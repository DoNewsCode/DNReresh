//
//  UIScrollView+DNRefresh.m
//  DNRefreshKit
//
//  Created by donews on 2018/10/17.
//

#import "UIScrollView+DNRefresh.h"
#import <objc/runtime.h>
#import "MMRefreshGifFrameAnimationHeader.h"

static char __headerKey,__footerKey;

@interface UIScrollView ()

@property (nonatomic, strong) MMRefreshStateHeader *header;
@property (nonatomic, strong) MMRefrashNewsListFooter *footer;

@end


@implementation UIScrollView (DNRefresh)

- (void)tg_headerRefreshExecutingBlock:(void (^)(void))executingBlock {
     [self tg_headerRefreshExecutingBlock:executingBlock gifType:MMRereshGifTypeDefault isChangeAlpha:NO];
}

- (void)tg_footerRefreshExecutingBlock:(void (^)(void))executingBlock {
    MMRefrashNewsListFooter *footer = [MMRefrashNewsListFooter refreshFooterWithStyle:nil loadingBlock:^{
        if (executingBlock) {
            executingBlock();
        }
    }];
    footer.triggerAutomaticallyLoadPercent = 3;
    self.mm_footer = footer;
    self.mm_footer.hidden = YES;
    self.footer = footer;
}

- (void)tg_headerRefreshExecutingBlock:(void (^)(void))executingBlock gifHeader:(MMRefreshGifHeader *)gifHeader isChangeAlpha:(BOOL)isChangeAlpha {
    
    gifHeader.loadingBlock = executingBlock;

    gifHeader.automaticallyChangeAlpha = isChangeAlpha;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;//如果不隐藏,会默认图片在最左边不是在中间
    gifHeader.stateLabel.hidden = NO; //隐藏状态
//    [gifHeader setTitle:@"22222" forState:MMRefreshStatePressing];
//    [gifHeader setTitle:@"111" forState:MMRefreshStateLoading];
    self.mm_header = gifHeader;
    self.header = gifHeader;
    
}

- (void)tg_headerRefreshExecutingBlock:(void (^)(void))executingBlock gifType:(MMRereshGifType)gifType isChangeAlpha:(BOOL)isChangeAlpha {
    if (gifType == MMRereshGifTypeFrameAnimation) {
        
        //下拉刷新
        MMRefreshStyle *headerStyle = [MMRefreshStyle new];
        MMRefreshGifFrameAnimationHeader *header = [MMRefreshGifFrameAnimationHeader refreshHeaderWithStyle:headerStyle loadingBlock:^{
            if (executingBlock) {
                executingBlock();
            }
        }];
        header.automaticallyChangeAlpha = isChangeAlpha;
        header.lastUpdatedTimeLabel.hidden = YES;//如果不隐藏,会默认图片在最左边不是在中间
//        header.stateLabel.hidden = YES; //隐藏状态
        header.stateLabel.hidden = NO; //隐藏状态
//        [header setTitle:@"22222" forState:MMRefreshStatePressing];
//        [header setTitle:@"111" forState:MMRefreshStateLoading];
        self.mm_header = header;
        self.header = header;
        
    } else {
        
        MMRefreshStyle *headerStyle = [MMRefreshStyle new];
        MMRefreshNormalHeader *header = [MMRefreshNormalHeader refreshHeaderWithStyle:headerStyle loadingBlock:^{
            if (executingBlock) {
                executingBlock();
            }
        }];
        header.animationImage = [self __arrowHeaderImage];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间

        
        [header setTitle:@"下拉刷新" forState:MMRefreshStateLoading];
        [header setTitle:@"松开刷新" forState:MMRefreshStatePressing];
        header.stateLabel.font = [UIFont systemFontOfSize:12];
        header.stateLabel.textColor = [UIColor redColor];
        
        self.mm_header =  header;
        self.header = header;
        
    }
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

//添加的 下拉刷新动图
- (FLAnimatedImage *)__arrowHeaderImage{
    FLAnimatedImage *arrowImage = nil;
    if (arrowImage == nil) {
        NSString *imgBundlePath = [[NSBundle mainBundle] pathForResource:@"MMRefresh" ofType:@"bundle"];
        NSBundle *imgBundle = [NSBundle bundleWithPath:imgBundlePath];
        NSString *imgPath = [imgBundle pathForResource:@"loading" ofType:@"gif"];
        NSData *imgdata = [NSData dataWithContentsOfFile:imgPath];
        arrowImage = [FLAnimatedImage animatedImageWithGIFData:imgdata];
    }
    return arrowImage;
}


@end
