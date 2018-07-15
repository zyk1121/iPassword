//
//  YKAddPasswordVC.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/8.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

class YKAddPasswordVC: YKBaseViewController {

    public let descLabel:UILabel = {
        let label = UILabel()
        label.text = "描述："
        label.textColor = UIColor.extColorWithHex("333333", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    public let accountLabel:UILabel = {
        let label = UILabel()
        label.text = "账号："
        label.textColor = UIColor.extColorWithHex("333333", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    public let passLabel:UILabel = {
        let label = UILabel()
        label.text = "密码："
        label.textColor = UIColor.extColorWithHex("333333", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "添加")
        setupUI()
        self.view.updateConstraintsIfNeeded()
    }
    
    func setupUI() {
        setRightNavButton()
        self.view.addSubview(descLabel)
        self.view.addSubview(accountLabel)
        self.view.addSubview(passLabel)
    }
    
    func setRightNavButton() {
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle("完成", for: .normal)
        rightButton.setTitleColor(YKMainColor, for: .normal)
        rightButton.addTarget(self, action: #selector(rightNavButtonClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.descLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.top.equalTo(self.view).offset(44)
        }
        
        self.accountLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.top.equalTo(self.descLabel.snp.bottom).offset(30)
        }
        
        self.passLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.top.equalTo(self.accountLabel.snp.bottom).offset(30)
        }
    }
    
    @objc func rightNavButtonClick()
    {
//        let vc = YKAddPasswordVC()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
