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

    private let mainView:YKQuestionLibMainView = YKQuestionLibMainView()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavLeftButton()
        setupUI()
        updateViewConstraints()
    }
    
    func setupUI() {
        setRightNavButton()
        self.view.addSubview(mainView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        mainView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func loadData()
    {
        self.mainView.setupEntity()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 验证密码
        YKPasswordSettingConfig.config.checkNeedVerify()
        self.loadData()
    }
}

