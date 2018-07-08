//
//  MainViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

// 主VC入口
class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // App主色调
        tabBar.tintColor = YKMainColor
    
        self.navigationController?.navigationBar.isHidden = true
        addViewControllers()
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
                addChildViewController("YKHomeViewController",titleName: "密保",imageName: "tabbar_home")
                addChildViewController("YKPhotoViewController",titleName: "相机",imageName: "tabbar_message_center")
                addChildViewController("YKPoemViewController",titleName: "诗词",imageName: "tabbar_discover")
                addChildViewController("YKMeViewController",titleName: "设置",imageName: "tabbar_profile")
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
    
    /*
     let vc = YKBaseViewController()
     vc.setLeftBarColor(color: UIColor.red)
     self.navigationController?.pushViewController(vc, animated: true)
     let vc  = YKBaseViewController()
     vc.setCloseBackButton()
     let nav = YKNavigationViewController(rootViewController: vc)
     self.present(nav, animated: true) {
     }*/
}

