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
#import "PADUser.h"
#import "NSString+Hash.h"
#import "NSData+AES.h"

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
    [PADUser defaultUser].userID = @"zyk1121";
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
    
    [self readDataFromFile];
//    [self writeDataToFile];
}

- (void)readDataFromFile
{
    NSString *homeDirectory = NSHomeDirectory();
    NSString *key = @"#zykpunycyy#2211";
    NSString *filepath = [NSString stringWithFormat:@"%@/Documents/%@",homeDirectory,[[PADUser defaultUser].userID md5String]];
    FILE *fp = fopen([filepath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    fseek(fp, 0, SEEK_END);
    unsigned int fileLen = (unsigned int)ftell(fp);
    fseek(fp, 0, SEEK_SET);
    unsigned char buf[2] = {0};
    fread(buf, 2, 1, fp);
    unsigned int len = 0;
    fread(&len, sizeof(unsigned int), 1, fp);
    unsigned char *bufData = (unsigned char *)malloc(len * sizeof(char) + 1);
    memset(bufData, 0, len+1);
    fread(bufData, len, 1, fp);
    NSData *userID = [NSData dataWithBytes:bufData length:len];
    NSString *userIDStr = [userID AES256DecryptWithKey_Str:key];
    [PADUser defaultUser].userID = userIDStr;
    free(bufData);
    bufData = NULL;
    unsigned int fileCurLen = (unsigned int)ftell(fp);
    [self.passData removeAllObjects];
    while (fileCurLen < fileLen - 2) {
        // 读取一个Pass数据
        // 长度
        fread(&len, sizeof(unsigned int), 1, fp);
        unsigned char *bufData = (unsigned char *)malloc(len * sizeof(char) + 1);
        memset(bufData, 0, len+1);
        fread(bufData, len, 1, fp);
    
        NSData *tempData = [NSData dataWithBytes:bufData length:len];
        
        id passwordDic = [NSJSONSerialization JSONObjectWithData:[tempData AES256DecryptWithKey:key] options:0 error:nil];
        if (passwordDic && [passwordDic isKindOfClass:[NSDictionary class]]) {
            PADPassword *password = [[PADPassword alloc] init];
            password.website = [passwordDic objectForKey:@"website"];
            password.account = [passwordDic objectForKey:@"account"];
            password.password = [passwordDic objectForKey:@"password"];
            password.reserved = [passwordDic objectForKey:@"reserved"];
            [self.passData addObject:password];
        }
        
        fileCurLen = (unsigned int)ftell(fp);
    }
    
    fclose(fp);
}

- (void)writeDataToFile
{
    if ([[PADUser defaultUser].userID length] > 0) {
        NSString *homeDirectory = NSHomeDirectory();
        NSString *filepath = [NSString stringWithFormat:@"%@/Documents/%@",homeDirectory,[[PADUser defaultUser].userID md5String]];
        FILE *fp = fopen([filepath cStringUsingEncoding:NSUTF8StringEncoding], "wb");
        unsigned char buf[2] = {0xff,0xfe};
        fwrite(buf, 2, 1, fp);
        // ID加密
        NSString *key = @"#zykpunycyy#2211";
        // 加密
        NSData *resultData = [[PADUser defaultUser].userID AES256EncryptWithKey:key];
        if (resultData) {
            unsigned int length = (unsigned int)[resultData length];
            fwrite(&length, sizeof(unsigned int), 1, fp);
            fwrite([resultData bytes], resultData.length, 1, fp);
        } else {
            fclose(fp);
            return;
        }
        //
        [self.passData enumerateObjectsUsingBlock:^(PADPassword*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = [self dataFromPassword:obj];
            unsigned int length = (unsigned int)[data length];
            fwrite(&length, sizeof(unsigned int), 1, fp);
            fwrite(data.bytes, length, 1, fp);
        }];
        fwrite(buf, 2, 1, fp);
        fclose(fp);
    }
}

- (NSData *)dataFromPassword:(PADPassword *)password
{
    NSData *data = nil;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    // website
    [dic setObject:password.website ? password.website : @"" forKey:@"website"];
    [dic setObject:password.account ? password.account : @"" forKey:@"account"];
    [dic setObject:password.password ? password.password : @"" forKey:@"password"];
    [dic setObject:password.reserved ? password.reserved : @"" forKey:@"reserved"];
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *key = @"#zykpunycyy#2211";
    data = [jsonData AES256EncryptWithKey:key];
    
    return data;
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
  
    
    UIBarButtonItem *updateBtn=[[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStylePlain target:self action:@selector(updateBtnClicked)];
    UIBarButtonItem *backupBtn=[[UIBarButtonItem alloc] initWithTitle:@"备份" style:UIBarButtonItemStylePlain  target:self action:@selector(backupBtnClicked)];
    NSArray *rightBtns=[NSArray arrayWithObjects:backupBtn,updateBtn, nil];
    self.navigationItem.rightBarButtonItems=rightBtns;

    [self.view setNeedsUpdateConstraints];
}

- (void)updateBtnClicked
{

}

- (void)backupBtnClicked
{
    
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
