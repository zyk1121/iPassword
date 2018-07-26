//
//  YKImageProcess.h
//  iPassword
//
//  Created by 张元科 on 2018/7/24.
//  Copyright © 2018年 SDJG. All rights reserved.
//

//#ifdef __cplusplus
//#import <opencv2/opencv.hpp>
//#import <opencv2/imgproc/types_c.h>
//#import <opencv2/imgcodecs/ios.h>
//#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#endif

#pragma clang pop


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YKImageProcess : NSObject

// 矫正
- (UIImage *)processImageRecify:(UIImage *)image;
// 红色下划线
- (UIImage *)processRedLine:(UIImage *)image;
// 返回红线对应的文本
- (NSString *)processWords:(NSString *)words pt1:(CGPoint)pt1 pt2:(CGPoint)pt2;
// 画矩行
- (UIImage *)drawRectangle:(UIImage *)image pt1:(CGPoint)pt1 pt2:(CGPoint)pt2;

// 获取ip地址
- (NSString *)getIpAddresses;
@end
