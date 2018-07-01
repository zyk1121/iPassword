//
//  MainViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // App主色调
        tabBar.tintColor = YKMainColor
        
        
        iPassSecure.shared().setupLoginPass("123456")
        if (iPassSecure.shared().checkPassword("123456")) {
            print("成功")
        } else {
            print("失败")
        }
        self.navigationItem.title = "iPass"
        
        let imv = UIImageView(image: UIImage(named: "naviBack"))
        imv.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
//        self.view.addSubview(imv)
//        self.navigationItem.leftBarButtonItem = nil
//        self.hideNavLeftButton()
        self.navigationController?.navigationBar.isHidden = true
        
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        addViewControllers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let vc = YKBaseViewController()
//        vc.setLeftBarColor(color: UIColor.red)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
//        let vc = YKBaseViewController()
//        vc.setLeftBarColor(color: UIColor.red)
//        self.navigationController?.pushViewController(vc, animated: true)
        /*
        let vc  = YKBaseViewController()
        vc.setCloseBackButton()
        let nav = YKNavigationViewController(rootViewController: vc)
        self.present(nav, animated: true) {
        }
 */
        
    }
    
    private func addViewControllers()
    {
        let path  = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil)
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            do {
                let dictArr = try JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                for dict in dictArr as! [[String:String]] {
                    addChildViewController(dict["vcName"]!, titleName: dict["title"]!, imageName: dict["imageName"]!)
                }
            } catch {
                addChildViewController("YKHomeViewController",titleName: "首页",imageName: "tabbar_home")
                addChildViewController("YKPhotoViewController",titleName: "消息",imageName: "tabbar_message_center")
                addChildViewController("YKPoemViewController",titleName: "发现",imageName: "tabbar_discover")
                addChildViewController("YKMeViewController",titleName: "我",imageName: "tabbar_profile")
            }
        }
    }
    
    private func addChildViewController(_ childControllerName: String,titleName:String, imageName:String) {
        // 动态获取命名空间
        let ns = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        let vcCls = cls as! UIViewController.Type
        let childController = vcCls.init()
        
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        childController.title = titleName
        let navVC = YKNavigationViewController()
        navVC.addChildViewController(childController)
        
        addChildViewController(navVC)
    }
}

