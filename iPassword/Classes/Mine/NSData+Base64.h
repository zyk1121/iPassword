//
//  NSData+Base64.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  64位数据方法
 */
@interface NSData (Base64)

/**
 *  对string进行基于64位的encode
 *
 *  @param string 需要encode的string
 *
 *  @return encoded data
 */
+ (NSData *) dataWithBase64EncodedString:(NSString *) string;

/**
 *  初始化string, 将其基于64位encoding
 *
 *  @param string 需要encode的string
 *
 *  @return NSData的instance
 */
- (id) initWithBase64EncodedString:(NSString *) string;

/**
 *  将基于64位的NSData转化成NSString, 不分行
 *
 *  @warning 
 *  @return 转化后的string
 */
- (NSString *) base64Encoding;

/**
 *  将基于64位的NSData转化成NSString, 按照参数分行
 *
 *  @param lineLength 每行string的长度
 *
 *  @return 转化好的string
 */
- (NSString *) base64EncodingWithLineLength:(unsigned int) lineLength;

/**
 *  将URL的NSData encode成String
 *
 *  @return encode之后的string
 */
- (NSString*) urlEncodedString;

@end
