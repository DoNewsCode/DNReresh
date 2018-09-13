//
//  MMRefreshGifFrameAnimationHeader.m
//  DNRefreshKit
//
//  Created by donews on 2018/9/13.
//

#import "MMRefreshGifFrameAnimationHeader.h"

@implementation MMRefreshGifFrameAnimationHeader

- (void)prepare {
    [super prepare];
    
    self.gifView.contentMode = UIViewContentModeScaleToFill;
    
    NSString *imgBundlePath = [[NSBundle mainBundle] pathForResource:@"MMRfreshGif" ofType:@"bundle"];
    NSArray *array = [NSBundle pathsForResourcesOfType:@"png" inDirectory:imgBundlePath];
    // 设置普通状态的动画图片
    NSMutableArray *images = [NSMutableArray array];
    for (NSUInteger i = 0; i< array.count; i++) {
        UIImage *image = [UIImage imageWithContentsOfFile:array[i]];
        [images addObject:image];
    }
    
    [self setImages:images forState:MMRefreshStateNormal];
    [self setImages:images forState:MMRefreshStateLoading];// 设置正在刷新状态的动画图片
    [self setImages:images forState:MMRefreshStatePressing];

}

@end
