//
//  YKHomeViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit
import LocalAuthentication
import SnapKit
import SDWebImage
import RxCocoa
import RxSwift

class YKHomeViewController: YKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavLeftButton()
        setupUI()
    }
    
    func setupUI() {
        setRightNavButton()
        
    }
    
    func setRightNavButton() {
        let rightButton = UIButton(type: .contactAdd)
        rightButton.addTarget(self, action: #selector(rightNavButtonClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func rightNavButtonClick()
    {
        let vc = YKAddPasswordVC()
         self.navigationController?.pushViewController(vc, animated: true)
        /*
//        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
//        self.hidesBottomBarWhenPushed = false
 */
//        appNavVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 验证密码
        YKPasswordSettingConfig.config.checkNeedVerify()
    }
}

