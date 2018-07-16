//
//  YKShowPasswordVC.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/15.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

class YKShowPasswordVC: YKBaseViewController {
    public var data:iPassSecureData?
    private weak var rightNavButton:UIButton?
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
    
    private let descTextField:YKBlankTextField = YKBlankTextField()
    private let accountTextField:YKBlankTextField = YKBlankTextField()
    private let passTextField:YKBlankTextField = YKBlankTextField()
    
    private var isAddSuccess:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "显示")
        setupUI()
        self.view.updateConstraintsIfNeeded()
    }
    
    func setupUI() {
        setRightNavButton()
        self.view.addSubview(descLabel)
        self.view.addSubview(accountLabel)
        self.view.addSubview(passLabel)
        self.view.addSubview(descTextField)
        descTextField.keyboardType = .default
        self.view.addSubview(accountTextField)
        accountTextField.keyboardType = .emailAddress
        self.view.addSubview(passTextField)
        passTextField.keyboardType = .numbersAndPunctuation
        descTextField.delegate = self
        accountTextField.delegate = self
        descTextField.delegate = self
        
//        descTextField.isUserInteractionEnabled = false
//        accountTextField.isUserInteractionEnabled = false
//        passTextField.isUserInteractionEnabled = false
        passTextField.isSecureTextEntry = true
        
        // 更新本地数据
        let desc = data?.content
        let account = data?.account
        let pass = data?.password
        descTextField.text = desc ?? ""
        accountTextField.text = account ?? ""
        passTextField.text = pass ?? ""
    }
    
    func setRightNavButton() {
        let rightButton = UIButton(type: .custom)
        self.rightNavButton = rightButton
        rightButton.setTitle("更新", for: .normal)
        rightButton.setTitleColor(YKMainColor, for: .normal)
        rightButton.addTarget(self, action: #selector(rightNavButtonClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightItem
        rightButton.isHidden = true
    }
    
    @objc func rightNavButtonClick()
    {
        if (checkChangedText()) {
            guard let desc = self.descTextField.text else {
                return
            }
            guard let account = self.accountTextField.text else {
                return
            }
            guard let pass = self.passTextField.text else {
                return
            }
            if desc.count > 100 || account.count > 100 || pass.count > 20 {
                return
            }
            self.data?.content = desc
            self.data?.account = account
            self.data?.password = pass
            if let entity = data {
                let isSuccess = iPassSecure.shared().updateItem(entity)
                if isSuccess {
                    CBToast.showToastAction(message: "更新成功！")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                        self.popBack()
                    }
                } else {
                    CBToast.showToastAction(message: "更新失败！")
                }
            }
        }
    }
    
    func checkChangedText()->Bool
    {
        self.rightNavButton?.isHidden = true
        guard let desc = self.descTextField.text else {
            return false
        }
        guard let account = self.accountTextField.text else {
            return false
        }
        guard let pass = self.passTextField.text else {
            return false
        }
        if desc.count > 100 || account.count > 100 || pass.count > 20 {
            return false
        }
        if let entity = data {
            if desc == entity.content && account == entity.account && pass == entity.password {
                // 相等
                self.rightNavButton?.isHidden = true
            } else {
                // 不相等
                self.rightNavButton?.isHidden = false
                return true
            }
        }
        return false
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
        self.descTextField.snp.remakeConstraints { (make) in
            make.left.equalTo(self.descLabel.snp.right).offset(0)
            make.centerY.equalTo(self.descLabel)
            make.right.equalTo(self.view).offset(-15)
        }
        self.accountTextField.snp.remakeConstraints { (make) in
            make.left.equalTo(self.accountLabel.snp.right).offset(0)
            make.centerY.equalTo(self.accountLabel)
            make.right.equalTo(self.view).offset(-15)
        }
        self.passTextField.snp.remakeConstraints { (make) in
            make.left.equalTo(self.passLabel.snp.right).offset(0)
            make.centerY.equalTo(self.passLabel)
            make.right.equalTo(self.view).offset(-15)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        passTextField.isSecureTextEntry = !passTextField.isSecureTextEntry
    }
}
extension YKShowPasswordVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == descTextField || textField == accountTextField {
            if let count = textField.text?.count {
                if count >= 100 {
                    return false
                }
            }
        }
        
        if textField == passTextField {
            if let count = textField.text?.count {
                if count >= 20 {
                    return false
                }
            }
        }
        
        DispatchQueue.main.async {
            _ = self.checkChangedText()
        }
        
        return true
    }
}
