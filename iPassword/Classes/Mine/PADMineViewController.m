//
//  PADMineViewController.m
//  iPassword
//
//  Created by zhangyuanke on 16/1/30.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import "PADMineViewController.h"
#import "Masonry.h"
#import "ASIKit/ASIKit.h"
#import "PADUIKitMacros.h"
#import "PADAccountView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PADUser.h"
#import "PADLoginViewController.h"

@interface PADMineViewController ()

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) PADAccountView *accountView;

@end

@implementation PADMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self setupUI];
}

- (void)setupUI
{
    _contentView = [[UIScrollView alloc] init];
    [self.view addSubview:_contentView];
    
    _accountView = ({
        PADAccountView *view = [[PADAccountView alloc] init];
        [self.contentView addSubview:view];
        view;
    });

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    [self.accountView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@76);
        make.width.equalTo(self.view);
    }];
    
    @weakify(self);
    [[RACObserve([PADUser defaultUser], userID) deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSString *userID) {
         @strongify(self);
         BOOL isUserValid = ([PADUser defaultUser].isUserAvailable && [userID length]);
         
         self.accountView.accountIconView.hidden = !isUserValid;
         self.accountView.userIDLabel.hidden = !isUserValid;
         self.accountView.logoutButton.hidden = !isUserValid;
         self.accountView.loginButton.hidden = isUserValid;
         
         if (isUserValid) {
             self.accountView.userIDLabel.text = userID;
         } else {
             self.accountView.userIDLabel.text = @"";
         }
     }];
    
    [[self.accountView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self login];
    }];
    
    [[self.accountView.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"退出");
        [PADUser defaultUser].userID = @"";
    }];
}

- (void)login
{
    PADLoginViewController *loginVC = [[PADLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
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
