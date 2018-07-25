//
//  YKTextShowViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/23.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

class YKTextShowViewController: YKBaseViewController {

    // 文本
    public var words:String = ""
    
    public let textView:UITextView = {
        let textF = UITextView()
        textF.text = ""
        textF.textColor = UIColor.extColorWithHex("333333", alpha: 1.0)
        textF.font = UIFont.systemFont(ofSize: 18)
        return textF
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "识别内容")
        textView.backgroundColor = UIColor.white
        textView.frame = CGRect(x: 0, y: 0, width: YK_ScreenWidth, height: YK_ScreenHeight - YK_NavHeight)
        textView.text = words
        self.view.addSubview(textView)
    }
    
    func setText(text:String) {
        words = text
    }
}
