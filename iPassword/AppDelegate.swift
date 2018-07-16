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
    weak var mainVC:UIViewController?

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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.isFileURL {
            // /private/var/mobile/Containers/Data/Application/79D83636-D136-4F73-B388-64898F1A3F14/tmp/com.zhangyuanke.iPassword-Inbox/iPass 2.data
            if (iPassSecure.shared().checkFilePassword(url.path)) {
                
                if (iPassSecure.shared().replace(withFile: url.path)) {
                    CBToast.showToastAction(message: "导入成功~")
                    NotificationCenter.default.post(name: NSNotification.Name.init("kYKReloadPasswordData"), object: nil)
                }
            } else {
                let alertView = UIAlertView(title: "导入失败", message: "导入文件密码和现在的不一致，不能导入~", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
//                CBToast.showToastAction(message: "导入文件密码和现在的不一致，不能导入~")
            }
        }
        return true
    }
}

extension AppDelegate {
    // 初始化主视图
    func showMainVC()
    {
        window = UIWindow(frame: UIScreen.main.bounds)
//        let vc = MainViewController()
//        window?.rootViewController = vc
        let vc = YKHomeViewController()
        let nav = YKNavigationViewController(rootViewController: vc)
        window?.rootViewController = nav
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
