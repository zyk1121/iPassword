//
//  MainViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

class MainViewController: YKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        iPassSecure.shared().setupLoginPass("123456")
        if (iPassSecure.shared().checkPassword("123456")) {
            print("成功")
        } else {
            print("失败")
        }
        self.navigationItem.title = "iPass"
        
        let imv = UIImageView(image: UIImage(named: "naviBack"))
        imv.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
        self.view.addSubview(imv)
//        self.navigationController?.navigationBar.isHidden = true
        
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
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
}

