//
//  PADLoginViewController.m
//  iPassword
//
//  Created by zhangyuanke on 16/1/31.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import "PADLoginViewController.h"
#import "Masonry.h"
#import "ASIKit/ASIKit.h"
#import "PADUIKitMacros.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PADUser.h"
#import "PADLoginView.h"

@interface PADLoginViewController ()

@property (nonatomic, strong) PADLoginView *loginView;

@end

@implementation PADLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    [self setupUI];
}

- (void)setupUI
{
    _loginView = ({
        PADLoginView *view = [[PADLoginView alloc] init];
        view;
    });
    [self.view addSubview:_loginView];
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(18);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

@end
