//
//  GzipUtility.h
//  LMK鉴权
//
//  Created by wangbingquanios on 16/4/19.
//  Copyright © 2016年 wangbingquanios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GzipUtility : NSObject

// 数据压缩

+ ( NSData *)compressData:( NSData *)uncompressedData;

// 数据解压缩

+ ( NSData *)decompressData:( NSData *)compressedData;
@end
