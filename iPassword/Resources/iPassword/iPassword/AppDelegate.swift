//
//  AppDelegate.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit
import AipBase
import AipOcrSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    weak var mainVC:UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        showMainVC()
        configOCR()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.isFileURL {
         
        }
        return true
    }
}

extension AppDelegate {
    // 初始化主视图
    func showMainVC()
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = YKPhotoViewController()
        let nav = YKNavigationViewController(rootViewController: vc)
        window?.rootViewController = nav
        mainVC = vc
        window?.makeKeyAndVisible()
    }
    
    func configOCR()
    {
        if let licenseFile = Bundle.main.path(forResource: "aip", ofType: "license") {
            let url = URL(fileURLWithPath: licenseFile)
            if let licenseFileData = try? Data(contentsOf: url) {
                AipOcrService.shard().auth(withLicenseFileData: licenseFileData)
            } else {
                let alertView = UIAlertView(title: "授权失败", message: "授权文件不存在", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
        }
    }
}
