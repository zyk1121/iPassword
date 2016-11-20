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
#import "PADPassword.h"
#import "PADEditPasswordViewController.h"
#import "PADUser.h"
#import "NSString+Hash.h"
#import "NSData+AES.h"
#import "AppDelegate.h"

@interface PADLoginViewController ()

@property (nonatomic, strong) PADLoginView *loginView;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation PADLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    // 1 获取token
    [self getToken];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    [self setupUI];
}

- (void)setupUI
{
    _loginView = ({
        PADLoginView *view = [[PADLoginView alloc] init];
        view;
    });
    [self.view addSubview:_loginView];
    
    _loginButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitle:@"登录" forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:25];
        button.layer.cornerRadius = 5;
        button.enabled = NO;
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_loginButton];
    
    @weakify(self);
    [RACObserve(self.loginView, userName) subscribeNext:^(id x) {
        @strongify(self);
        if (self.loginView.userName.length >= 6 && self.loginView.password.length >= 6) {
            self.loginButton.enabled = YES;
        } else {
            self.loginButton.enabled = NO;
        }
    }];
    
    [RACObserve(self.loginView, password) subscribeNext:^(id x) {
        @strongify(self);
        if (self.loginView.userName.length >= 6 && self.loginView.password.length >= 6) {
            self.loginButton.enabled = YES;
        } else {
            self.loginButton.enabled = NO;
        }
    }];
    
    [self.view updateConstraintsIfNeeded];
}

- (void)loginButtonClicked
{
    [self.view endEditing:YES];
    // 点击登录按钮
    [self readDataFromFile];
    // 本地文件中获取用户名和密码
}

- (void)readDataFromFile
{
    NSString *homeDirectory = NSHomeDirectory();
    NSString *key = @"#zykpunycyy#2211";
    NSString *filepath = [NSString stringWithFormat:@"%@/Documents/%@",homeDirectory,[self.loginView.userName md5String]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        // 本地文件没有，从网络获取
        [self getFileFromWeb];
        
    } else {
        // 直接读取本地文件数据
        FILE *fp = fopen([filepath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
//        fseek(fp, 0, SEEK_END);
//        fseek(fp, 0, SEEK_SET);
        unsigned char buf[2] = {0};
        fread(buf, 2, 1, fp);
        unsigned int len = 0;
        fread(&len, sizeof(unsigned int), 1, fp);
        unsigned char *bufData = (unsigned char *)malloc(len * sizeof(char) + 1);
        memset(bufData, 0, len+1);
        fread(bufData, len, 1, fp);
        NSData *userID = [NSData dataWithBytes:bufData length:len];
        NSString *userIDStr = [userID AES256DecryptWithKey_Str:key];
        // 用户名 & 密码
        if ([self.loginView.userName isEqualToString:userIDStr]) {
            [PADUser defaultUser].userID = userIDStr;
            // 登录成功
            [self loginSuccess];
        } else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者密码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];
        }
        free(bufData);
        bufData = NULL;
        
        fclose(fp);
    }
}

- (void)loginSuccess
{
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *del = (AppDelegate *)application.delegate;
    del.window.rootViewController = del.tabBarController;
}


- (void)getFileFromWeb
{
    NSString *fileName = [self.loginView.userName md5String];
//    http://7xrj8s.com1.z0.glb.clouddn.com/94894ef13d1d2a3e6a99e09481480d04
    NSString *urlStr = [NSString stringWithFormat:@"http://7xrj8s.com1.z0.glb.clouddn.com/%@",fileName];
    NSURL *url = [NSURL URLWithString:urlStr];
    //2.创建一个可变的请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //2.1 请求方法
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 100;
    //设置请求头
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {
         NSLog(@"ddd");
     }];

    
}

- (void)getToken
{
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"https://acc.qbox.me/oauth2/token"];
    //2.创建一个可变的请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //2.1 请求方法
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 100;
    //设置请求头
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    //[request setValue:@"password" forHTTPHeaderField:@"grant_type"];
    //[request setValue:@"5320944896@qq.com" forHTTPHeaderField:@"username"];
    //[request setValue:@"zy1k1121" forHTTPHeaderField:@"password"];
    
    
//    NSString *param = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",@"5@qq.com",@"zyk11213"];
    
//    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    // request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    //    3.建立连接,发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {
        
        if ([data length] && connectionError == nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (result) {
                // 成功  "expires_in" = 3600; 60分钟过期
                [PADUser defaultUser].accessToken = [result objectForKey:@"access_token"];
                [PADUser defaultUser].refreshToken = [result objectForKey:@"refresh_token"];
            }
        }
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

//- (void)cancelAction
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(18);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
}

@end
