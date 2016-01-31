//
//  PADBaseViewController.m
//  iPassword
//
//  Created by zhangyuanke on 16/1/31.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import "PADBaseViewController.h"
#import "PADUIKitMacros.h"

@implementation PADBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = HEXCOLOR(0xf2f2f4);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self setupNavigationBar];
}

- (void)setupNavigationBar
{
    self.navigationController.navigationBar.barTintColor = RGBCOLOR(249, 249, 249);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.navigationController.navigationBar.translucent = NO;
}

@end
