//
//  AppDelegate.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    weak var mainVC:MainViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        showMainVC()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        YKPasswordSettingConfig.config.backgroundMode = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        YKPasswordSettingConfig.config.checkNeedVerify()
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }
}

extension AppDelegate {
    // 初始化主视图
    func showMainVC()
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = MainViewController()
        window?.rootViewController = vc
        mainVC = vc
        window?.makeKeyAndVisible()
        // 第一次设置密码
        checkPassword()
    }
    
    func checkPassword()
    {
        // 第一次设置
        YKPasswordSettingConfig.config.firstCheck()
    }
}
