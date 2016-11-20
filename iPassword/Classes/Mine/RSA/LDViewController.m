//
//  ViewController.m
//  LMK鉴权
//
//  Created by wangbingquanios on 16/4/18.
//  Copyright © 2016年 wangbingquanios. All rights reserved.
//

#import "RSA.h"
#import "LDViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Hash.h"

@interface ViewController ()

@end

@implementation ViewController
//-(NSString*)getScode{
- (void)viewDidLoad
{
    [super viewDidLoad];
//    LMKAuthenticationClientInfo* info = [[LMKAuthenticationClientInfo alloc] init];
    //    NSString *aa =  info.platformString;
    //    NSLog(@"%@",aa);
    //    NSString *sss = info.currentWifiBSSID;
    //    NSLog(@"%@",sss);
//    //    NSLog(@"%@",info.clientInfoArr);
//    NSString* hello = @"hello";
//    NSString* aa = [self base64Encode:hello];
//    NSLog(@"aaaaaaa:%@", aa);
//    [info clientInfoFromClientInfoArrayToBytesArray:info.clientInfoArr];

//    [self postLogin];
    [self test];
}
-(NSString*)getTimeSp{
    
       NSDate *datenow = [NSDate date];
      return [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
}

- (NSString *)formatPublicKey:(NSString *)publicKey
{
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    int count = 0;
    
    for (int i = 0; i < [publicKey length]; ++i) {
        
        unichar c = [publicKey characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        [result appendFormat:@"%c", c];
        if (++count == 76) {
            [result appendString:@"\n"];
            count = 0;
        }
    }
    
    [result appendString:@"\n-----END PUBLIC KEY-----\n"];
    
    return result;
    
}

- (void)test
{
    NSString* originString = @"hello";
    
    NSData *ceshidata = [originString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* publicKeyStr = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFoAkykHtfxJJpD9UGIHM6/Z41\nL9pHlDlFCH10CcVDDRMAP3ilNQBMUFHBGM7qxNsTPGlcpYOOyQ5JaWcpL+EI+dUD\nmL+rdM6vpvIGIxKIgZv12qntHytheT9xs/ouvooZ6JHu2874Wa981sUqwlr5L8o7\nZFc8Dix2CQn4L5Eq8wIDAQAB\n-----END PUBLIC KEY-----";
    NSString *priviateStr = @"-----BEGIN PRIVATE KEY-----\nMIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMWgCTKQe1/EkmkP\n1QYgczr9njUv2keUOUUIfXQJxUMNEwA/eKU1AExQUcEYzurE2xM8aVylg47JDklp\nZykv4Qj51QOYv6t0zq+m8gYjEoiBm/Xaqe0fK2F5P3Gz+i6+ihnoke7bzvhZr3zW\nxSrCWvkvyjtkVzwOLHYJCfgvkSrzAgMBAAECgYA4vf+GDifuUmF7WvleHfkX6fP/\n73Jr9OoQoSRsKdYCr4FSI+c/AB3Ky5D9sWLP05/XQRQ7bqZ8W8wHVgUxtTaWPAF7\nbXg/MdOl+BDobY/Sj8XisMdaJ9QBz+QZ55eGRKMDI5Nap5hRjausSJHAF7JknrYq\nodcUW9nx864A3f0SOQJBAP7UiDgoJRyH+xsxP780qufWCudncH1BTB7F4Fef5SV2\nkh+GasP1VkJiwX7vumPDHn72u/Oo6TBFJgvhO5N5rwcCQQDGiEdCHyscTwi8XUbk\n1gOXLqCCgNMWiCXe9XSF3lK89jOh1FiBHDZv4IHDvvR3Gi7jj6H+/YAd9swcH8OI\n3n21AkB/Wdd5uRZS2+IyBLrG45tFoUJxwtAEyM0x09H5+H6b6lW8S4Cvzbv+ETyC\nI2wSz0A+UzA65P8kkGojJbyQRw+hAkBXrjhKa5mOlxk0l72Hsz1Ct8UL3flcKiUP\nozgjJ11DNzj2b+Hmo58nKfAlk2BEebvbpMPW6f57PVRH1390I09BAkEAsCX0DGes\njxR1YRiSUGQz/F4XyVvfohpTIuQPKksm5oiK4uj9rqGNuAN4oFCR7rAtqwrVRPiC\nWMPoz2ic9vrSwA==\n-----END PRIVATE KEY-----";
        NSData *aa =   [RSA encryptData:ceshidata publicKey:publicKeyStr];
    
    
    
        NSData *data = [RSA decryptData:aa privateKey:priviateStr];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self test];
//    [self postLogin];
//    NSLog(@"%@",[self RSAEncrypotoTheData:@"hello"]);
    
}

//-(SecKeyRef)getPublicKey{
//    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"keystore" ofType:@"p7b"];
//    SecCertificateRef myCertificate = nil;
//    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
//    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
//    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
//    SecTrustRef myTrust;
//    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
//    SecTrustResultType trustResult;
//    if (status == noErr) {
//        status = SecTrustEvaluate(myTrust, &trustResult);
//    }
//    return SecTrustCopyPublicKey(myTrust);
//}


-(NSString *)RSAEncrypotoTheData:(NSString *)plainText
{
    
    SecKeyRef publicKey=nil;
     NSString* publicKeyStr = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFoAkykHtfxJJpD9UGIHM6/Z41\nL9pHlDlFCH10CcVDDRMAP3ilNQBMUFHBGM7qxNsTPGlcpYOOyQ5JaWcpL+EI+dUD\nmL+rdM6vpvIGIxKIgZv12qntHytheT9xs/ouvooZ6JHu2874Wa981sUqwlr5L8o7\nZFc8Dix2CQn4L5Eq8wIDAQAB\n-----END PUBLIC KEY-----";
    publicKey=[RSA addPublicKey:publicKeyStr];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = NULL;
    
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = cipherBufferSize-11;  // 这个地方比较重要是加密问组长度
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,[plainTextBytes length]-i*blockSize);
        NSData *buffer = plainTextBytes;//[plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                       initWithBytes:(const void *)cipherBuffer
                                       length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    NSString *encrypotoResult=[[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    return encrypotoResult;
}

//- (void)postLogin
//{
//    LMKAuthenticationClientInfo* info = [[LMKAuthenticationClientInfo alloc] init];
//    
//      NSData *dataa = [info clientInfoFromClientInfoArrayToBytesArray:info.clientInfoArr];
//    
//
//    NSString* originString = @"hello";
//
//    NSData *ceshidata = [originString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //   NSString *sssd = [self base64Encode:originString];
//    //    NSLog(@"%@sssd",sssd);
//
//    //    NSLog(@"Original string(%d): %@", (int)originString.length, originString);
//    NSString* publicKeyStr = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFoAkykHtfxJJpD9UGIHM6/Z41\nL9pHlDlFCH10CcVDDRMAP3ilNQBMUFHBGM7qxNsTPGlcpYOOyQ5JaWcpL+EI+dUD\nmL+rdM6vpvIGIxKIgZv12qntHytheT9xs/ouvooZ6JHu2874Wa981sUqwlr5L8o7\nZFc8Dix2CQn4L5Eq8wIDAQAB\n-----END PUBLIC KEY-----";
//    NSString *priviateStr = @"-----BEGIN PRIVATE KEY-----\nMIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMWgCTKQe1/EkmkP\n1QYgczr9njUv2keUOUUIfXQJxUMNEwA/eKU1AExQUcEYzurE2xM8aVylg47JDklp\nZykv4Qj51QOYv6t0zq+m8gYjEoiBm/Xaqe0fK2F5P3Gz+i6+ihnoke7bzvhZr3zW\nxSrCWvkvyjtkVzwOLHYJCfgvkSrzAgMBAAECgYA4vf+GDifuUmF7WvleHfkX6fP/\n73Jr9OoQoSRsKdYCr4FSI+c/AB3Ky5D9sWLP05/XQRQ7bqZ8W8wHVgUxtTaWPAF7\nbXg/MdOl+BDobY/Sj8XisMdaJ9QBz+QZ55eGRKMDI5Nap5hRjausSJHAF7JknrYq\nodcUW9nx864A3f0SOQJBAP7UiDgoJRyH+xsxP780qufWCudncH1BTB7F4Fef5SV2\nkh+GasP1VkJiwX7vumPDHn72u/Oo6TBFJgvhO5N5rwcCQQDGiEdCHyscTwi8XUbk\n1gOXLqCCgNMWiCXe9XSF3lK89jOh1FiBHDZv4IHDvvR3Gi7jj6H+/YAd9swcH8OI\n3n21AkB/Wdd5uRZS2+IyBLrG45tFoUJxwtAEyM0x09H5+H6b6lW8S4Cvzbv+ETyC\nI2wSz0A+UzA65P8kkGojJbyQRw+hAkBXrjhKa5mOlxk0l72Hsz1Ct8UL3flcKiUP\nozgjJ11DNzj2b+Hmo58nKfAlk2BEebvbpMPW6f57PVRH1390I09BAkEAsCX0DGes\njxR1YRiSUGQz/F4XyVvfohpTIuQPKksm5oiK4uj9rqGNuAN4oFCR7rAtqwrVRPiC\nWMPoz2ic9vrSwA==\n-----END PRIVATE KEY-----";
//    
//    
//    priviateStr = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMWgCTKQe1/EkmkP1QYgczr9njUv2keUOUUIfXQJxUMNEwA/eKU1AExQUcEYzurE2xM8aVylg47JDklpZykv4Qj51QOYv6t0zq+m8gYjEoiBm/Xaqe0fK2F5P3Gz+i6+ihnoke7bzvhZr3zWxSrCWvkvyjtkVzwOLHYJCfgvkSrzAgMBAAECgYA4vf+GDifuUmF7WvleHfkX6fP/73Jr9OoQoSRsKdYCr4FSI+c/AB3Ky5D9sWLP05/XQRQ7bqZ8W8wHVgUxtTaWPAF7bXg/MdOl+BDobY/Sj8XisMdaJ9QBz+QZ55eGRKMDI5Nap5hRjausSJHAF7JknrYqodcUW9nx864A3f0SOQJBAP7UiDgoJRyH+xsxP780qufWCudncH1BTB7F4Fef5SV2kh+GasP1VkJiwX7vumPDHn72u/Oo6TBFJgvhO5N5rwcCQQDGiEdCHyscTwi8XUbk1gOXLqCCgNMWiCXe9XSF3lK89jOh1FiBHDZv4IHDvvR3Gi7jj6H+/YAd9swcH8OI3n21AkB/Wdd5uRZS2+IyBLrG45tFoUJxwtAEyM0x09H5+H6b6lW8S4Cvzbv+ETyCI2wSz0A+UzA65P8kkGojJbyQRw+hAkBXrjhKa5mOlxk0l72Hsz1Ct8UL3flcKiUPozgjJ11DNzj2b+Hmo58nKfAlk2BEebvbpMPW6f57PVRH1390I09BAkEAsCX0DGesjxR1YRiSUGQz/F4XyVvfohpTIuQPKksm5oiK4uj9rqGNuAN4oFCR7rAtqwrVRPiCWMPoz2ic9vrSwA==";
//    // Demo: encrypt with public key
////    NSString* pubKeySre = [RSA encryptString:originString publicKey:publicKeyStr];
////    NSData *aa =   [RSA encryptData:ceshidata publicKey:publicKeyStr];
////    
////    NSData *data = [RSA decryptData:aa privateKey:priviateStr];
////    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////    
////   NSString *tt = [aa base64EncodedStringWithOptions:0];
////    NSLog(@"%@-----------wwwww",tt);
////    NSData *baseD = [[NSData alloc] initWithBase64EncodedString:tt options:0];
//    NSString *androidS = @"NEJCNkIzQTA0QTg4N0Q5RjcyNDVDRTMxRDdDMzgwNjVDM0YzQUIyMkM2MzI2RkUwNzlDQjAzM0U1QjA2MDM3QjdDMERDNjVFMkM0MUQ4MjI5MTI3QzlCRkQxQTM1RTBBN0VBREEyMzMwMzI4N0E2NDRDOUE2NzQyNEZBNTk1NzExRUJGN0Y4Qzc3RDQ5OUZDQkZFRENFMTcwNzM3MkE2NjhEMTQ2MDRDOERCQjcyREMyODIzMEM4RDc4RDZBMUQwOEFCRDJEMUJERTM0OTU2RURFNzIwMzM3N0Q2QTUxOUYzQUQxQjI4RTE1MjU5MjRGNTM2REI5ODYxRTZBOEZEQg==";
//    
//    
//    NSString *dd = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFoAkykHtfxJJpD9UGIHM6/Z41L9pHlDlFCH10CcVDDRMAP3ilNQBMUFHBGM7qxNsTPGlcpYOOyQ5JaWcpL+EI+dUDmL+rdM6vpvIGIxKIgZv12qntHytheT9xs/ouvooZ6JHu2874Wa981sUqwlr5L8o7ZFc8Dix2CQn4L5Eq8wIDAQAB";
//    
//    
//    NSUInteger length = [androidS length];
////     NSString *lll = [self formatPublicKey:priviateStr];
//    NSData *d1 = [[NSData alloc] initWithBase64EncodedString:androidS options:0];
//    NSData *d2 = [RSA decryptData:d1 privateKey:priviateStr];
//    unsigned char *str = [d2 bytes];
//    unsigned char dddd[1024] = {0};
//    memcpy(dddd, str, [d2 length]);
//    NSLog(@"%s",dddd);
//    NSString *sss = [[NSString alloc] initWithData:d2 encoding:NSUTF8StringEncoding];
//    
////   
////    NSString *lll = [self formatPublicKey:dd];
//    
// 
//
//    
////        NSLog(@"Enctypted with public key: %@", tt);
////
//////
////    //1.NSURL
////    NSURL* url = [NSURL URLWithString:@"http://192.168.120.23:25001/msp/v3/mobile/auth"];
////
////    //2.创建一个可变的请求
////    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
////    //2.1 请求方法
////    request.HTTPMethod = @"POST";
////    request.timeoutInterval = 15;
////    //设置请求头
//////    [request setValue:pubKeySre forHTTPHeaderField:@"X-INFO"];
////    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
////    [request setValue:@"platform=iOS&sdkversion=3.3.1&product=3dmap" forHTTPHeaderField:@"platinfo"];
////    [request setValue:@"AMAP_SDK_iOS_3DMap_3.3.1" forHTTPHeaderField:@"User-Agent"];
////   //logversion字段可能未添加
//////    [request setValue:@"2.1" forHTTPHeaderField:@"logversion"];
////    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
////    [request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
////    //2.2 把数据放入到请求体里面
//////      NSString *timeSp = [NSString stringWithFormat:@"%d", (long)[datenow timeIntervalSince1970]];
////    NSString* param = @"encode=UTF-8&resType=json&ts=1456905221210&ak=35eb086b311983688108129eff1a6b05&scode=261b1f8c2ba8c2e4a5dfd32ab8cd8512";
////
////    //NSData--->oc 反序列化
////    NSString*scodeBeforeMD5 = @"B4:DA:CE:CA:1C:89:62:65:03:25:4B:7C:A3:DC:B6:75:F5:09:81:07:com.leador.map.demo:1461063276111";
////   NSString *md5 = [scodeBeforeMD5 md5String];
////    NSLog(@"%@ -----md5",md5);
////    //oc--->NSData
////
////    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
////
//////    3.建立连接,发送请求
////    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
////        if (connectionError == nil && data != nil && data.length > 0) {
////            //4.处理服务器返回的数据(反序列化)
////            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
////
////            NSLog(@"post======%@", result);
////
////            //4.1 将用户名和密码,存放在(偏好设置)里面,当我下次需要自动登录的时候,从偏好设置里面取出来,发送给服务器
////
////            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
////
////            //[userDefaults setObject:@"zhangsan" forKey:@"username"];
////            //[userDefaults setObject:@"zhang" forKey:@"password"];
////            [userDefaults setObject:[self base64Encode:@"zhangsan"] forKey:@"username"];
////            [userDefaults setObject:[self base64Encode:@"zhang"] forKey:@"password"];
////
////            //同步,iOS8之后,不用写,自动会同步,但是如果你要兼容iOS7,必须写上
////            [userDefaults synchronize];
////        }
////        else {
////            NSLog(@"%@", connectionError);
////        }
////    }];
////}
//}

/**
 *  将一个base64编码后的字符串还原成原始的明文
 *
 *  @param base64Str base64编码后的字符串
 *
 *  @return 最终还原成的明文
 */
- (NSString*)base64Decode:(NSString*)base64Str
{
    //1.首先将base64字符串转NSData
    NSData* base64Data = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];

    //2.再次NSData还原成最原始的字符串
    NSString* originalStr = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];

    return originalStr;
}

/**
 *  将一个原始的字符串比如 "zhangsan" 转成一个经过base64编码之后的字符串
 这种base64之后的字符串,就不像我们的明文那么好理解,这样在一定程度上,起到保护我们用户隐私的目的
 *
 *  @param originalStr 原始的字符串
 *
 *  @return base64编码之后的字符串
 */
- (NSString*)base64Encode:(NSString*)originalStr
{
    //1.得把原始字符串转成二进制
    NSData* base64Data = [originalStr dataUsingEncoding:NSUTF8StringEncoding];

    //2.再将上面转好的二进制,编码成base64的字符串
    NSString* base64Str = [base64Data base64EncodedStringWithOptions:0];

    return base64Str;
}

- (NSString*)generateUrl:(NSString*)url
{
    NSString* encodedString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(
        NULL,
        (__bridge CFStringRef)url,
        NULL,
        CFSTR("+"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return encodedString;
}

@end
