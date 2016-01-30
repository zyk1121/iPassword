//
//  ViewController.m
//  iPassword
//
//  Created by zhangyuanke on 16/1/30.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "ASIKit/ASIKit.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iPassword";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI
{
    _button = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"测试" forState:UIControlStateNormal];
        [button setTitle:@"测试" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(runtest) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_button];

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)runtest
{
//    /*示例为列取http://my-bucket.sinastorage.cn/images/jpegs中最多50个object*/
//    
//    ASIS3BucketRequest *listRequest = [ASIS3BucketRequest requestWithBucket:@"bucket-kdtm"];
//    [listRequest setPrefix:@"/data/user/contents"];
//    [listRequest setMaxResultCount:50]; // Max number of results
//    [listRequest startSynchronous];
//    
//    if (![listRequest error]) {
//        NSLog(@"%@",[listRequest objects]);
//    } else {
//        NSLog(@"ddd");
//    }
    
    
//    NSString *filePath = @"/Users/Yuanke/user.json";
//    
//    ASIS3ObjectRequest *request = [ASIS3ObjectRequest PUTRequestForFile:filePath withBucket:@"bucket-kdtm" key:@"/data/user/contents/user.json"];
//    [request startSynchronous];
//    
//    if ([request error]) {
//        NSLog(@"%@",[[request error] localizedDescription]);
//    } else {
//        NSLog(@"dd");
//    }
    
//    ASIS3ObjectRequest *request = [ASIS3ObjectRequest DELETERequestWithBucket:@"bucket-kdtm" key:@"/data/user/contents"];
//    [request startSynchronous];
//    
//    if ([request error]) {
//        NSLog(@"%@",[[request error] localizedDescription]);
//    }
    /*示例为获取http://my-bucket.sinastorage.cn/path/to/the/object的object信息*/
    
    NSString *bucket = @"bucket-kdtm";
    NSString *path = @"/data/user/contents/user.json";
    
    ASIS3ObjectRequest *request = [ASIS3ObjectRequest requestWithBucket:bucket key:path];
    [request startSynchronous];
    
    if (![request error]) {
        NSData *data = [request responseData];
        NSString *str=  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [data writeToFile:@"/Users/Yuanke/123.json" atomically:YES];
//        NSLog(@"%@",data);
    } else {
        NSLog(@"%@",[[request error] localizedDescription]);
    }
}

@end
