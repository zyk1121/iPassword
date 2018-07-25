//
//  ImageProcess.cpp
//  iPassword
//
//  Created by 张元科 on 2018/7/24.
//  Copyright © 2018年 SDJG. All rights reserved.
//

#include "ImageProcess.hpp"


#define ERROR_PRCESS 99999

//度数转换
double DegreeTrans(double theta)
{
    double res = theta / CV_PI * 180;
    return res;
}

//逆时针旋转图像degree角度（原尺寸）
void rotateImage(Mat src, Mat& img_rotate, double degree)
{
    
    //旋转中心为图像中心
    Point2f center;
    center.x = float(src.cols / 2.0);
    center.y = float(src.rows / 2.0);
    int length = 0;
    length = sqrt(src.cols*src.cols + src.rows*src.rows) * 2;
    // 计算二维旋转的仿射变换矩阵
    Mat M = getRotationMatrix2D(center, degree, 1);
    
    double tempDe = degree > 0 ? degree : -degree;
    tempDe = tempDe / 180 * CV_PI;
    float w = src.cols * cos(tempDe) + src.rows * sin(tempDe);
    float h = src.cols * sin(tempDe) + src.rows * cos(tempDe);
    warpAffine(src, img_rotate, M, Size(w, h), 1, 0, Scalar(255,255,255));//仿射变换，背景色填充为白色
}

//通过霍夫变换计算角度
double CalcDegree(const Mat &srcImage, Mat &dst)
{
    Mat midImage, dstImage;
    
    Canny(srcImage, midImage, 50, 200, 3);
    cvtColor(midImage, dstImage, CV_GRAY2BGR);
    
    //通过霍夫变换检测直线
    vector<Vec2f> lines;
    HoughLines(midImage, lines, 1, CV_PI / 180, 300, 0, 0);//第5个参数就是阈值，阈值越大，检测精度越高
    
    //由于图像不同，阈值不好设定，因为阈值设定过高导致无法检测直线，阈值过低直线太多，速度很慢
    //所以根据阈值由大到小设置了三个阈值，如果经过大量试验后，可以固定一个适合的阈值。
    
    if (!lines.size())
    {
        HoughLines(midImage, lines, 1, CV_PI / 180, 200, 0, 0);
    }
    
    if (!lines.size())
    {
        HoughLines(midImage, lines, 1, CV_PI / 180, 150, 0, 0);
    }

    if (!lines.size())
    {
        return ERROR_PRCESS;
    }
    
    float sum = 0;
    //依次画出每条线段
    for (size_t i = 0; i < lines.size(); i++)
    {
        float rho = lines[i][0];
        float theta = lines[i][1];
        Point pt1, pt2;
        
        double a = cos(theta), b = sin(theta);
        double x0 = a*rho, y0 = b*rho;
        pt1.x = cvRound(x0 + 1000 * (-b));
        pt1.y = cvRound(y0 + 1000 * (a));
        pt2.x = cvRound(x0 - 1000 * (-b));
        pt2.y = cvRound(y0 - 1000 * (a));
        //只选角度最小的作为旋转角度
        sum += theta;
        
        line(dstImage, pt1, pt2, Scalar(55, 100, 195), 1, LINE_AA); //Scalar函数用于调节线段颜色
        
    }
    float average = sum / lines.size(); //对所有角度求平均，这样做旋转效果会更好
    
    double angle = DegreeTrans(average) - 90;
    
    rotateImage(dstImage, dst, angle);
    return angle;
}


void ImageRecify(Mat src, Mat& dst)
{
    double degree;
    //倾斜角度矫正
    degree = CalcDegree(src,dst);
    if (degree == ERROR_PRCESS)
    {
        return;
    }
    rotateImage(src, dst, degree);
}

void colorFilter(CvMat *inputImage, CvMat *&outputImage)
{
    int i, j;
    IplImage* image = cvCreateImage(cvGetSize(inputImage), 8, 3);
    cvGetImage(inputImage, image);
    IplImage* hsv = cvCreateImage( cvGetSize(image), 8, 3 );
    
    cvCvtColor(image,hsv,CV_BGR2HSV);
    int width = hsv->width;
    int height = hsv->height;
    for (i = 0; i < height; i++)
        for (j = 0; j < width; j++)
        {
            CvScalar s_hsv = cvGet2D(hsv, i, j);//获取像素点为（j, i）点的HSV的值
            /*
             opencv 的H范围是0~180，红色的H范围大概是(0~8)∪(160,180)
             S是饱和度，一般是大于一个值,S过低就是灰色（参考值S>80)，
             V是亮度，过低就是黑色，过高就是白色(参考值220>V>50)。
             */
            CvScalar s;
            if (!(((s_hsv.val[0]>0)&&(s_hsv.val[0]<8)) || (s_hsv.val[0]>120)&&(s_hsv.val[0]<180)))
            {
                s.val[0] =0;
                s.val[1]=0;
                s.val[2]=0;
                cvSet2D(hsv, i ,j, s);
            }
        }
    outputImage = cvCreateMat( hsv->height, hsv->width, CV_8UC3 );
    cvConvert(hsv, outputImage);
    cvReleaseImage(&hsv);
}
