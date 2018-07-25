//
//  YKImageProcess.m
//  iPassword
//
//  Created by 张元科 on 2018/7/24.
//  Copyright © 2018年 SDJG. All rights reserved.
//

#import "YKImageProcess.h"
#import "ImageProcess.hpp"

@interface YKImageProcess()
{
    cv::Mat _dst;
}
@end

@implementation YKImageProcess

- (UIImage *)processImageRecify:(UIImage *)image {
    cv::Mat src,gray;
    UIImageToMat(image, src);
    // 灰度
    cv::cvtColor(src, gray, cv::COLOR_RGB2GRAY);
    cv::Mat dst;
    double degree;
    // 倾斜角度矫正
    degree = CalcDegree(src,dst);
    rotateImage(src, dst, degree);
    UIImage *img = MatToUIImage(dst);
    // 矫正后的image
    return img;
}

- (UIImage *)processRedLine:(UIImage *)image {
    cv::Mat src,hsv;
    UIImageToMat(image, src);
    cv::cvtColor(src,hsv,cv::COLOR_RGB2HSV);
    int width = hsv.cols;
    int height = hsv.rows;
    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++)
        {
            /*
             opencv 的H范围是0~180，红色的H范围大概是(0~8)∪(160,180)
             S是饱和度，一般是大于一个值,S过低就是灰色（参考值S>80)，
             V是亮度，过低就是黑色，过高就是白色(参考值220>V>50)。
             */
            
            Vec3b v = hsv.at<Vec3b>(i, j);
            if (!((v[0] > 0 && v[0] < 8) || (v[0] > 160 && v[0] < 180))) {
                v[0] = 0;
                v[1] = 0;
                v[2] = 0;
            }
            hsv.at<Vec3b>(i, j) = v;
        }
    
    // 转灰度
    cv::Mat gray;
    cv::cvtColor(hsv, gray, cv::COLOR_RGB2GRAY);
    // 阈值
    cv::threshold(gray, _dst, 120, 255, CV_THRESH_BINARY);
    
    UIImage *img = MatToUIImage(_dst);
    return img;
}

// 返回红线对应的文本
- (NSString *)processWords:(NSString *)words pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
    NSInteger startIndex = -1;
    NSInteger endInex = -1;
    NSInteger count = words.length;
    if (count <= 0) {
        return @"";
    }
    CGFloat span = (pt2.x - pt1.x ) / count;
    
    for (int i = 0; i < count;i++) {
        int xPos = int(pt1.x + i * span + span / 2);
        int yPos = int(pt2.y + 0);
        cv::Point pt;
        pt.x = xPos;
        pt.y = yPos;
        if ([self hasRedLine:pt span:int(span / 2)]) {
            if (startIndex >= 0) {
                endInex = i;
            } else {
                startIndex = i;
                endInex = i;
            }
        }
    }
    if (startIndex >= 0) {
        NSRange range = NSMakeRange(startIndex, endInex-startIndex + 1);
        return [words substringWithRange:range];
    }
    return @"";
}

- (BOOL)hasRedLine:(cv::Point)pt span:(int)span
{
    if (_dst.cols <= 0 || _dst.rows <= 0 || pt.x >= _dst.cols || pt.y >= _dst.rows) {
        return NO;
    }
    int count = 0;
    if (span < 10) {
        span = 10;
    }
    for (int i = -span; i < span; i++) {
        for (int j = -span; j < 2*span; j++) {
            if (pt.x + i < 0 || pt.x + i >= _dst.cols) {
                continue;
            }
            if (pt.y + j < 0 || pt.y + j >= _dst.rows) {
                continue;
            }
            uchar v = _dst.at<uchar>(pt.y + j,pt.x + i);
            if (v > 0) {
                count += 1;
            }
        }
    }
    if (count >= 5) {
        return YES;
    }
    return NO;
}

- (UIImage *)drawRectangle:(UIImage *)image pt1:(CGPoint)pt1 pt2:(CGPoint)pt2
{
    cv::Mat src;
    UIImageToMat(image, src);
    cv::Mat dst;
    cv::Scalar s;
    s[0] = 255;
    s[1] = 0;
    s[2] = 0;
    cv::Point p1;
    p1.x = (int)pt1.x;
    p1.y = (int)pt1.y;
    cv::Point p2;
    p2.x = (int)pt2.x;
    p2.y = (int)pt2.y;
    cv::rectangle(src, p1, p2, s);
    UIImage *img = MatToUIImage(src);
    return img;
}

@end
