//
//  DNViewController.m
//  DNRefreshKit
//
//  Created by 540563689@qq.com on 09/07/2018.
//  Copyright (c) 2018 540563689@qq.com. All rights reserved.
//

#import "DNViewController.h"
#import <DNRefreshKit/UIScrollView+Refresh.h>

@interface DNViewController () <UITableViewDelegate, UITableViewDataSource>
    
@property (nonatomic, strong) UITableView *tabelView;

@end

@implementation DNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tabelView];

     [self.tabelView tg_headerRefreshExecutingBlock:^{
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
             [NSThread sleepForTimeInterval:1];
             dispatch_async(dispatch_get_main_queue(), ^{
                  [self.tabelView tg_headerEndRefresh];
             });
         });
     } gifType:MMRereshGifTypeFrameAnimation isChangeAlpha:NO];
    
    
//    //下拉刷新
//    DNRefreshGifHeader *header = [DNRefreshGifHeader refreshHeaderWithStyle:nil loadingBlock:^{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [NSThread sleepForTimeInterval:1];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tabelView.mm_header endLoading];
//            });
//        });
//    }];
    
//    DNRefreshGifHeader *header = [DNRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
//    self.tabelView.mm_header = header;
//    DNRefreshGifHeader *header =  [[DNRefreshGifHeader alloc] init];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"Test";
    return cell;
}
    
#pragma mark - Getters & Setters
- (UITableView *)tabelView {
    if(_tabelView == nil) {
        CGRect frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height);
        _tabelView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tabelView.dataSource = self;
        _tabelView.delegate = self;
        [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tabelView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
