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
        textView.isEditable = false
        self.view.addSubview(textView)
        setRightNavButton()
    }
    
    func setRightNavButton() {
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle("保存", for: .normal)
        rightButton.setTitleColor(YKMainColor, for: .normal)
        rightButton.addTarget(self, action: #selector(rightNavButtonClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func rightNavButtonClick()
    {
        if words.count > 0 {
            // 从1开始
            let fileCount = UserDefaults.standard.integer(forKey: "kYKFilesKey")
            let dir = "\(NSHomeDirectory())/Documents/data"
            let filename = "\(dir)/\(fileCount).txt"
            // 写入文件
            if let data = words.data(using: .utf8) {
                let url = URL(fileURLWithPath: filename)
                try? data.write(to: url)
                CBToast.showToastAction(message: "保存文件成功!")
                UserDefaults.standard.set(fileCount + 1, forKey: "kYKFilesKey")
                UserDefaults.standard.synchronize()
            }
        } else {
             CBToast.showToastAction(message: "内容为空~")
        }
        // UserDefaults.standard.integer(forKey: "kYKFilesKey")
        UserDefaults.standard.set(1, forKey: "kYKFilesKey")
        UserDefaults.standard.synchronize()
    }
    
    func setText(text:String) {
        words = text
        UIPasteboard.general.string = text
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
             CBToast.showToastAction(message: "可以直接在微信或QQ中粘贴哦~")
        }
    }
}
