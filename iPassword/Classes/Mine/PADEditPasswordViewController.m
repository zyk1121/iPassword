//
//  PADEditPasswordViewController.m
//  iPassword
//
//  Created by zhangyuanke on 16/11/20.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import "PADEditPasswordViewController.h"
#import "Masonry.h"
#import "PADUIKitMacros.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PADEditPasswordViewController ()

@property (nonatomic, strong) UIScrollView *contentView;

@end

@implementation PADEditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细";
    [self setupUI];
    
    UIBarButtonItem *saveBtn=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClicked)];
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain  target:self action:@selector(cancelBtnClicked)];
    NSArray *rightBtns=[NSArray arrayWithObjects:cancelBtn,saveBtn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;
}

- (void)saveBtnClicked
{
}

- (void)cancelBtnClicked
{

}
- (void)setupUI
{
    _contentView = [[UIScrollView alloc] init];
    [self.view addSubview:_contentView];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    
}

@end
