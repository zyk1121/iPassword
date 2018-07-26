//
//  ImageProcess.hpp
//  iPassword
//
//  Created by 张元科 on 2018/7/24.
//  Copyright © 2018年 SDJG. All rights reserved.
//

#ifndef ImageProcess_hpp
#define ImageProcess_hpp
#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include <iostream>
using namespace cv;
using namespace std;

#include <stdio.h>

double CalcDegree(const Mat &srcImage, Mat &dst);
void rotateImage(Mat src, Mat& img_rotate, double degree);
void colorFilter(CvMat *inputImage, CvMat *&outputImage);
#endif /* ImageProcess_hpp */
