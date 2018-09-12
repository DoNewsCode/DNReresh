# DNRefreshKit

[![CI Status](https://img.shields.io/travis/540563689@qq.com/DNRefreshKit.svg?style=flat)](https://travis-ci.org/540563689@qq.com/DNRefreshKit)
[![Version](https://img.shields.io/cocoapods/v/DNRefreshKit.svg?style=flat)](https://cocoapods.org/pods/DNRefreshKit)
[![License](https://img.shields.io/cocoapods/l/DNRefreshKit.svg?style=flat)](https://cocoapods.org/pods/DNRefreshKit)
[![Platform](https://img.shields.io/cocoapods/p/DNRefreshKit.svg?style=flat)](https://cocoapods.org/pods/DNRefreshKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
【用法 给TableView添加下拉刷新】 

导入头文件 `#import <DNRefreshKit/UIScrollView+Refresh.h>`

```

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tabelView];
    
    @weakify(self)
    [self.tabelView tg_headerRefreshExecutingBlock:^{
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabelView tg_headerEndRefresh];
        });
    }];
}

```

【例如给UIColletionView添加上拉、下拉刷新】

```
// 下拉刷新
@weakify(self)
[self.collectionView tg_headerRefreshExecutingBlock:^{
        @strongify(self)
        self.newsListRequest.page = 1;
        [self.collectionView tg_footerEndRefresh];
        [self tg_loadData];
}];
    
[self.collectionView tg_footerRefreshExecutingBlock:^{
        @strongify(self)
        self.newsListRequest.page++;
        [self.collectionView tg_headerEndRefresh];
        [self tg_loadData];
}];    
```  
  【修改默认的下拉刷新的gif图标】
  
  * 在项目创建名为 `MMRefresh.bundle`资源文件夹
  * 命名图片为`loading.gif` 的图片拖入资源文件夹

  ![](./images/img1.png)
  
## Installation

DNRefreshKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DNRefreshKit'
```

## Author

540563689@qq.com, zhengjia@donews.com

## License

DNRefreshKit is available under the MIT license. See the LICENSE file for more info.


