//
//  YKHomeViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit
import LocalAuthentication

class YKHomeViewController: YKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavLeftButton()
        
    }
    
    func checkTouchID()
    {
        //1.初始化TouchID句柄
        let authentication = LAContext()
        var error: NSError?
        
        //2.检查Touch ID是否可用
        let isAvailable = authentication.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                           error: &error)
        
        //3.处理结果
        if isAvailable
        {
            NSLog("Touch ID is available")
            //这里是采用认证策略 LAPolicy.DeviceOwnerAuthenticationWithBiometrics
            //--> 指纹生物识别方式
            authentication.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "这里需要您的指纹来进行识别验证", reply: {
                //当调用authentication.evaluatePolicy方法后，系统会弹提示框提示用户授权
                (success, error) -> Void in
                if success
                {
                    NSLog("您通过了Touch ID指纹验证！")
                }
                else
                {
                    //上面提到的指纹识别错误
                    NSLog("您未能通过Touch ID指纹验证！错误原因：\n\(error)")
                }
            })
        }
        else
        {
            //上面提到的硬件配置
            NSLog("Touch ID不能使用！错误原因：\n\(error)")
        }
    }
}


/*
 - (IBAction)onclickButton:(id)sender {
 //新建LAContext实例
 LAContext  *authenticationContext= [[LAContext alloc]init];
 NSError *error;
 //1:检查Touch ID 是否可用
 if ([authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
 NSLog(@"touchId 可用");
 //2:执行认证策略
 [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
 if (success) {
 NSLog(@"通过了Touch Id指纹验证");
 }else{
 NSLog(@"error===%@",error);
 NSLog(@"code====%d",error.code);
 NSLog(@"errorStr ======%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
 if (error.code == -2) {//点击了取消按钮
 NSLog(@"点击了取消按钮");
 }else if (error.code == -3){//点输入密码按钮
 NSLog(@"点输入密码按钮");
 }else if (error.code == -1){//连续三次指纹识别错误
 NSLog(@"连续三次指纹识别错误");
 }else if (error.code == -4){//按下电源键
 NSLog(@"按下电源键");
 }else if (error.code == -8){//Touch ID功能被锁定，下一次需要输入系统密码
 NSLog(@"Touch ID功能被锁定，下一次需要输入系统密码");
 }
 NSLog(@"未通过Touch Id指纹验证");
 }
 }];
 }else{
 //todo goto 输入密码页面
 NSLog(@"error====%@",error);
 NSLog(@"抱歉，touchId 不可用");
 }
 }
 
 作者：kuazi
 链接：https://www.jianshu.com/p/4446c082d771
 來源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
 */
