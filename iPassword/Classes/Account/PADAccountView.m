//
//  PADAccountView.m
//  ipassword
//
//  Created by zhangyuanke on 15/11/23.
//  Copyright © 2015年 meituan. All rights reserved.
//

#import "PADAccountView.h"
#import "PADUIKitMacros.h"
#import "Masonry.h"

@interface PADAccountView ()

@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation PADAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _accountIconView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"icon_mine_default_portrait.png"];
            imageView;
        });
        [self addSubview:_accountIconView];
        
        _userIDLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = HEXCOLOR(0x333333);
            label.font = Font(16);
            label;
        });
        [self addSubview:_userIDLabel];
        
        _separatorLine = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = HEXCOLOR(0xd8d8d8);
            view;
        });
        [self addSubview:_separatorLine];
        
        _logoutButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:@"退出" forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0x06c1ae) forState:UIControlStateNormal];
            button.titleLabel.font = Font(15);
            button;
        });
        [self addSubview:_logoutButton];
        
        _loginButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:@"立即登陆" forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0x06c1ae) forState:UIControlStateNormal];
            button.titleLabel.font = Font(15);
            button;
        });
        [self addSubview:_loginButton];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    [self.accountIconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.centerY.equalTo(self);
        make.width.equalTo(@49);
        make.height.equalTo(@49);
    }];
    
    [self.userIDLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountIconView.mas_right).offset(12);
        make.centerY.equalTo(self);
        make.height.equalTo(@18);
    }];
    
    
    [self.logoutButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIDLabel.mas_right).offset(12);
        make.centerY.equalTo(self);
        make.height.equalTo(@18);
    }];
    
    
    [self.separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [super updateConstraints];
}

@end
