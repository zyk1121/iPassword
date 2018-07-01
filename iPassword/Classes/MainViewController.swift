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
    }
}

