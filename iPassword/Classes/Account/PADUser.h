//
//  PADUser.h
//  iPassword
//
//  Created by zhangyuanke on 16/1/31.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PADUser : NSObject

@property (nonatomic, strong) NSString *userID;

+ (PADUser *)defaultUser;

- (BOOL)isUserAvailable;

@end
