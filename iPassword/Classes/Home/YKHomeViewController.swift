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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 验证密码
        YKPasswordSettingConfig.config.checkNeedVerify()
    }
}

