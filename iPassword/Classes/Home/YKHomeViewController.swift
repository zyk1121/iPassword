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
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavLeftButton()
        setupUI()
        setLeftNavButton()
        updateViewConstraints()
    }
    
    func setupUI() {
        setRightNavButton()
        self.view.addSubview(mainView)
        mainView.parentVC = self
        NotificationCenter.default.rx.notification(Notification.Name.init("kYKReloadPasswordData")).subscribe {[weak self] (event) in
            self?.loadData()
        }.disposed(by: disposeBag)
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
    
    func setLeftNavButton()
    {
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle("备份", for: .normal)
        rightButton.setTitleColor(YKMainColor, for: .normal)
        rightButton.addTarget(self, action: #selector(leftNavButtonClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.leftBarButtonItem = rightItem
    }
    func setRightNavButton() {
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle("添加", for: .normal)
        rightButton.setTitleColor(YKMainColor, for: .normal)
        rightButton.addTarget(self, action: #selector(rightNavButtonClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func rightNavButtonClick()
    {
        let vc = YKAddPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func leftNavButtonClick()
    {
        let vc = YKPassSettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 验证密码
        YKPasswordSettingConfig.config.checkNeedVerify()
        self.loadData()
    }
}

