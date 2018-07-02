//
//  YKPasswordSettingView.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/2.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

// 密码视图类型
enum YKPasswordSettingType:Int {
    case setting_step_one
    case setting_step_two
    case verify
    case change_step_one
    case change_step_two
}

// 全局的视图
private var kYKSettingPassView:YKPasswordSettingView? = nil
// YKMainIconColor
// 密码设置页面
class YKPasswordSettingView: UIView {
    
    var settingType:YKPasswordSettingType = .setting_step_one
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupUI()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
    
    }
    
    public static func showPasswordSettingViewWith(type:YKPasswordSettingType) {
        if kYKSettingPassView != nil {
            kYKSettingPassView?.removeFromSuperview()
        }
        let passSettingView = YKPasswordSettingView(frame: UIScreen.main.bounds)
        passSettingView.settingType = type
        YK_KEY_WINDOW?.addSubview(passSettingView)
        kYKSettingPassView = passSettingView
    }
}
