//
//  PADUser.h
//  iPassword
//
//  Created by zhangyuanke on 16/1/31.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PADUser : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;

+ (PADUser *)defaultUser;

- (BOOL)isUserAvailable;

@end
