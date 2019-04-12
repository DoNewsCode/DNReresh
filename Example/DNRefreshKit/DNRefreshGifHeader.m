//
//  DNRefreshGifHeader.m
//  DNRefreshKit_Example
//
//  Created by donews on 2018/9/13.
//  Copyright © 2018年 540563689@qq.com. All rights reserved.
//

#import "DNRefreshGifHeader.h"

@implementation DNRefreshGifHeader

- (void)prepare {
    [super prepare];
    
    self.gifView.contentMode = UIViewContentModeScaleToFill;
    
    NSString *imgBundlePath = [[NSBundle mainBundle] pathForResource:@"A9VG" ofType:@"bundle"];
    NSArray *array = [NSBundle pathsForResourcesOfType:@"png" inDirectory:imgBundlePath];
    NSString *path = array.firstObject;
    NSString *baseUrl = path.stringByDeletingLastPathComponent;

    // 设置普通状态的动画图片
    NSMutableArray *images = [NSMutableArray array];
    for (NSUInteger i = 0; i< array.count; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%@/%zd",baseUrl,i];
        UIImage *image = [UIImage imageWithContentsOfFile:imgName];
        [images addObject:image];
    }
    
//    [self setImages:images forState:MMRefreshStateNormal];
//    [self setImages:images forState:MMRefreshStateLoading];// 设置正在刷新状态的动画图片
    [self setTitle:@"111" forState:MMRefreshStateLoading];
    [self setTitle:@"222" forState:MMRefreshStateLoading];
    
//    [self setImages:images forState:MMRefreshStatePressing];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;//如果不隐藏,会默认图片在最左边不是在中间
    //隐藏状态
    self.stateLabel.hidden = YES;
}

@end
