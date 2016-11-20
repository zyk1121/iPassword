//
//  PADUser.m
//  iPassword
//
//  Created by zhangyuanke on 16/1/31.
//  Copyright © 2016年 kdtm. All rights reserved.
//

#import "PADUser.h"

static PADUser *defaultUser;

@implementation PADUser

+ (PADUser *)defaultUser
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUser = [[PADUser alloc] init];
    });
    return defaultUser;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userID = nil;
        _accessToken = nil;
    }
    return self;
}

- (BOOL)isUserAvailable
{
    return [self.userID length] > 0;
}

@end
