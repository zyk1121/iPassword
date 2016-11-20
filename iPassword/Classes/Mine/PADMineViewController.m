//
//  PADMineViewController.m
//  iPassword
//
//  Created by zhangyuanke on 16/1/30.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import "PADMineViewController.h"
#import "Masonry.h"
#import "PADUIKitMacros.h"
#import "PADAccountView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PADUser.h"
#import "PADLoginViewController.h"
#import "PADPassword.h"
#import "PADEditPasswordViewController.h"

@interface PADMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) PADAccountView *accountView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *passData;

@end

@implementation PADMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self loadData];
    [self setupUI];
}

- (void)loadData
{
    self.passData = [[NSMutableArray alloc] init];
    // 从本地加载数据
    PADPassword *pass = [[PADPassword alloc] init];
    pass.website = @"百度文库";
    pass.account = @"zyk1121";
    pass.password = @"cyy1122";
    pass.reserved = @"备注信息";
    [self.passData addObject:pass];
    
    
    PADPassword *pass2 = [[PADPassword alloc] init];
    pass2.website = @"新浪微博";
    pass2.account = @"zyk1121";
    pass2.password = @"cyy1122";
    pass2.reserved = @"备注信息";
    [self.passData addObject:pass2];
}

- (void)setupUI
{
    _contentView = [[UIScrollView alloc] init];
    [self.view addSubview:_contentView];
    
//    _accountView = ({
//        PADAccountView *view = [[PADAccountView alloc] init];
//        [self.contentView addSubview:view];
//        view;
//    });
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        // 53 184 174
        CGSize size = [UIScreen mainScreen].bounds.size;
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, size.width, 50)];
        addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [addButton setImage:[UIImage imageNamed:@"icon_add.jpg"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"icon_add.jpg"] forState:UIControlStateSelected];
        [addButton setImage:[UIImage imageNamed:@"icon_add.jpg"] forState:UIControlStateHighlighted];
        addButton.center = CGPointMake(size.width / 2, 30);
        [addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 0.5)];
        topLine.backgroundColor  = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 59, size.width, 0.5)];
        bottomLine.backgroundColor  = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 60)];
        [view addSubview:topLine];
        [view addSubview:addButton];
        [view addSubview:bottomLine];
        
        view.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = view;
        
        [self.contentView addSubview:tableView];
        tableView;
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
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44);
    }];
    
}

- (void)addButtonClicked:(UIButton *)button
{
    PADEditPasswordViewController *vc = [[PADEditPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"tableViewCellIdetify_passrord";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    PADPassword *password = [self.passData objectAtIndex:indexPath.row];
    if (password) {
         cell.textLabel.text = password.website;
        cell.textLabel.font = [UIFont systemFontOfSize:26];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.passData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
//    view.backgroundColor = [UIColor grayColor];
//    return view;
//}


@end

//    [self.accountView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView);
//        make.left.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//        make.height.equalTo(@76);
//        make.width.equalTo(self.view);
//    }];
//    
//    @weakify(self);
//    [[RACObserve([PADUser defaultUser], userID) deliverOn:[RACScheduler mainThreadScheduler]]
//     subscribeNext:^(NSString *userID) {
//         @strongify(self);
//         BOOL isUserValid = ([PADUser defaultUser].isUserAvailable && [userID length]);
//         
//         self.accountView.accountIconView.hidden = !isUserValid;
//         self.accountView.userIDLabel.hidden = !isUserValid;
//         self.accountView.logoutButton.hidden = !isUserValid;
//         self.accountView.loginButton.hidden = isUserValid;
//         
//         if (isUserValid) {
//             self.accountView.userIDLabel.text = userID;
//         } else {
//             self.accountView.userIDLabel.text = @"";
//         }
//     }];
//    
//    [[self.accountView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        [self login];
//    }];
//    
//    [[self.accountView.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"退出");
//        [PADUser defaultUser].userID = @"";
//    }];


//- (void)login
//{
//    PADLoginViewController *loginVC = [[PADLoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:nav animated:YES completion:nil];
//}



//@end
