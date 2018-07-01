//
//  YKCommonDefine.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

public let isiPhoneX = UIScreen.main.bounds.size.height == 812 ? true : false

public let YK_Nav_SubViewY :CGFloat = isiPhoneX ? 40.0 : 20.0

public let YK_NavHeight :CGFloat  = isiPhoneX ? 88 : 64

public let YK_TabbarHeight :CGFloat = isiPhoneX ? 73.5 : 49.5

//获取屏幕宽
public let YK_ScreenWidth = UIScreen.main.bounds.size.width

//获取屏幕高
public let YK_ScreenHeight = UIScreen.main.bounds.size.height

// 当前设备与iPhone6宽度比
public  let YK_ScreenRate = YK_ScreenWidth / 375.0

// 当前设备与iPhone6高度比
public let YK_ScreenHeightRate = YK_ScreenHeight / 667.0

// 获取应用主窗口
// 警告：不要在主窗口显示之前调用
public let YK_KEY_WINDOW = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow

// 导航栏返回按钮的颜色
public let YKNaviBackArrowColor = UIColor.extColorWithHex("323232", alpha: 1.0)

