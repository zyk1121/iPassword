//
//  PADPassword.h
//  iPassword
//
//  Created by zhangyuanke on 16/11/20.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PADPassword : NSObject

@property (nonatomic, copy) NSString *website;// 网站类型
@property (nonatomic, copy) NSString *account;// 账户信息
@property (nonatomic, copy) NSString *password;// 密码
@property (nonatomic, copy) NSString *reserved;// 备注信息

@end
