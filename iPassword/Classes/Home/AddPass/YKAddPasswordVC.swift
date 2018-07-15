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
    
    private let descTextField:YKBlankTextField = YKBlankTextField()
    private let accountTextField:YKBlankTextField = YKBlankTextField()
    private let passTextField:YKBlankTextField = YKBlankTextField()
    
    private var isAddSuccess:Bool = false
    
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
        self.view.addSubview(descTextField)
        descTextField.placeholder = "请输入描述信息（限100字符）"
        descTextField.keyboardType = .default
        self.view.addSubview(accountTextField)
        accountTextField.placeholder = "请输入账号信息（限100字符）"
        accountTextField.keyboardType = .emailAddress
        self.view.addSubview(passTextField)
        passTextField.placeholder = "请输入密码（限20字符）"
        passTextField.keyboardType = .numbersAndPunctuation
        
        descTextField.delegate = self
        accountTextField.delegate = self
        passTextField.delegate = self
        
        // 更新本地数据
        let desc = UserDefaults.standard.value(forKey: "kYKAddPass_Desc") as? String
        let account = UserDefaults.standard.value(forKey: "kYKAddPass_Account") as? String
        let pass = UserDefaults.standard.value(forKey: "kYKAddPass_Pass") as? String
        descTextField.text = desc ?? ""
        accountTextField.text = account ?? ""
        passTextField.text = pass ?? ""
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
        self.view.endEditing(true)
    }
    
    override func popBack() {
        
        if isAddSuccess {
            UserDefaults.standard.removeObject(forKey: "kYKAddPass_Desc")
            UserDefaults.standard.removeObject(forKey: "kYKAddPass_Account")
            UserDefaults.standard.removeObject(forKey: "kYKAddPass_Pass")
            UserDefaults.standard.synchronize()
        } else {
            guard let desc = self.descTextField.text else {
                return
            }
            guard let account = self.accountTextField.text else {
                return
            }
            guard let pass = self.passTextField.text else {
                return
            }
            // 存储到本地
            UserDefaults.standard.set(desc, forKey: "kYKAddPass_Desc")
            UserDefaults.standard.set(account, forKey: "kYKAddPass_Account")
            UserDefaults.standard.set(pass, forKey: "kYKAddPass_Pass")
            UserDefaults.standard.synchronize()
            
            if desc.count > 100 {
                UserDefaults.standard.removeObject(forKey: "kYKAddPass_Desc")
            }
            if account.count > 100 {
                UserDefaults.standard.removeObject(forKey: "kYKAddPass_Account")
            }
            if pass.count > 20 {
                UserDefaults.standard.removeObject(forKey: "kYKAddPass_Pass")
            }
            UserDefaults.standard.synchronize()
        }
        
        super.popBack()
    }
    
    @objc func rightNavButtonClick()
    {
        guard let desc = self.descTextField.text else {
            return
        }
        guard let account = self.accountTextField.text else {
            return
        }
        guard let pass = self.passTextField.text else {
            return
        }
        if desc.count <= 0 {
            CBToast.showToastAction(message: "输入描述为空~")
        }
        if account.count <= 0 {
            CBToast.showToastAction(message: "输入账号为空~")
        }
        if pass.count <= 0 {
            CBToast.showToastAction(message: "输入密码为空~")
        }
        // 都不为空
        let data = iPassSecureData()
        data.account = account
        data.content = desc
        data.password = pass
        data.type = 1
        data.level = 1
        data.state = 0
        let isSuccess = iPassSecure.shared().insertItem(data)
        if isSuccess {
            CBToast.showToastAction(message: "添加成功！")
            isAddSuccess = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                self.popBack()
            }
        } else {
            CBToast.showToastAction(message: "添加失败！")
        }
    }
}

extension YKAddPasswordVC : UITextFieldDelegate {
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
        
        return true
    }
}

class YKBlankTextField:UITextField {
    
    var bottomLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI()
    {
        bottomLine.backgroundColor = UIColor.extColorWithHex("353e54", alpha: 0.5)
        self.textColor = UIColor.extColorWithHex("6BBFFF", alpha: 1.0)
        self.addSubview(bottomLine)
        updateConstraintsIfNeeded()
    }
    
    override var isEnabled: Bool {
        willSet {
            if newValue {
                bottomLine.backgroundColor = UIColor.extColorWithHex("353e54", alpha: 0.5)
                self.textColor = UIColor.extColorWithHex("6BBFFF", alpha: 1.0)
            } else {
                bottomLine.backgroundColor = UIColor.extColorWithHex("353e54", alpha: 0.5)
            }
            _ = resignFirstResponder()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        bottomLine.backgroundColor = UIColor.extColorWithHex("6BBFFF", alpha: 1.0)
        self.textColor = UIColor.extColorWithHex("6BBFFF", alpha: 1.0)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        bottomLine.backgroundColor = UIColor.extColorWithHex("353e54", alpha: 0.5)
        self.textColor = UIColor.extColorWithHex("6BBFFF", alpha: 1.0)
        return super.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        bottomLine.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(1.5)
            make.bottom.equalTo(self).offset(-1.5)
        }
        super.updateConstraints()
    }
    
    deinit {
        
    }
}
