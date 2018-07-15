//
//  iPassSecure.h
//  iPassSecure
//
//  Created by 张元科 on 2018/6/28.
//  Copyright © 2018年 SDJG. All rights reserved.
//

#import <Foundation/Foundation.h>

/*存储的数据结构:外部控制数据结构的合理性*/
@interface iPassSecureData:NSObject

@property (nonatomic, assign) int index;// 索引
@property (nonatomic, assign) int level;// 安全级别，默认1
@property (nonatomic, assign) int type;// 类型
@property (nonatomic, assign) int state;// 是否可用
@property (nonatomic, copy) NSString *content;// 描述 120
@property (nonatomic, copy) NSString *account;// 账户 120
@property (nonatomic, copy) NSString *password;// 密码 20

@end

/*
 * 加密解密相关功能
 */
@interface iPassSecure : NSObject

+ (iPassSecure *)sharedSecure;
// 密码只能设置一次
- (BOOL)setupLoginPass:(NSString *)pass;
// 校验密码是否正确（低等级）
- (BOOL)checkPassword:(NSString *)loginpass;
- (BOOL)insertItem:(iPassSecureData *)item;
- (BOOL)updateItem:(iPassSecureData *)item;
- (BOOL)deleteItem:(iPassSecureData *)item;
- (NSArray<iPassSecureData *> *)getAllData;

// 文件相关
- (BOOL)checkFilePassword:(NSString *)filePath;
- (BOOL)replaceWithFile:(NSString *)filePath;

@end
