//
//  PADLoginView.m
//  iPassword
//
//  Created by zhangyuanke on 16/1/31.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import "PADLoginView.h"
#import "Masonry.h"
#import "ASIKit/ASIKit.h"
#import "PADUIKitMacros.h"

@interface PADLoginView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UIView *separationLineTop;
@property (nonatomic, strong) UIView *separationLineCenter;
@property (nonatomic, strong) UIView *separationLineBottom;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation PADLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _userNameTextField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.textColor = [UIColor colorWithWhite:0.2 alpha:1];
            textField.font = [UIFont systemFontOfSize:15];
            textField.delegate = self;
            [textField addTarget:self action:@selector(textDidChangeForUserName:) forControlEvents:UIControlEventEditingChanged];
            textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.returnKeyType = UIReturnKeyNext;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.adjustsFontSizeToFitWidth = YES;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.rightViewMode = UITextFieldViewModeUnlessEditing;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField;
        });
        [self addSubview:_userNameTextField];
        
        _separationLineTop = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = HEXCOLOR(0xcccccc);
            view;
        });
        [self addSubview:_separationLineTop];
        
        _separationLineCenter = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = HEXCOLOR(0xcccccc);
            view;
        });
        [self addSubview:_separationLineCenter];
        
        _separationLineBottom = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = HEXCOLOR(0xcccccc);
            view;
        });
        [self addSubview:_separationLineBottom];
        
        _passwordTextField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.textColor = [UIColor colorWithWhite:0.2 alpha:1];
            textField.font = [UIFont systemFontOfSize:15];
            textField.delegate = self;
            [textField addTarget:self action:@selector(textDidChangeForPassword:) forControlEvents:UIControlEventEditingChanged];
            textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.returnKeyType = UIReturnKeyNext;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.adjustsFontSizeToFitWidth = YES;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.rightViewMode = UITextFieldViewModeUnlessEditing;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField;
        });
        [self addSubview:_passwordTextField];
        
        [self.userNameTextField becomeFirstResponder];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    [self.userNameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(@18);
        make.right.equalTo(self).offset(-18);
        make.height.equalTo(@50);
    }];
    
    [self.passwordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom);
        make.left.equalTo(@18);
        make.right.equalTo(self).offset(-18);
        make.height.equalTo(@50);
        make.bottom.equalTo(self);
    }];
    
    [self.separationLineTop mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_top);
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.separationLineCenter mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom);
        make.left.equalTo(self).offset(18);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.separationLineBottom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [super updateConstraints];
}

#pragma mark - event

- (void)textDidChangeForUserName:(UITextField *)textField
{
    self.userName = textField.text;
}

- (void)textDidChangeForPassword:(UITextField *)textField
{
    self.password = textField.text;
}

@end
