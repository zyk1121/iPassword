//
//  YKPhotoViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit
import AipBase
import AipOcrSdk

class YKPhotoViewController: YKBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavLeftButton()
        setTitle(title: "文字识别")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        test()
    }
    
    func test()
    {
        if let vc = AipGeneralVC.viewController(handler: { (image) in
            let options = ["language_type":"CHN_ENG","detect_direction":"true"]
            AipOcrService.shard().detectTextBasic(from: image, withOptions: options, successHandler: { (value) in
                DispatchQueue.main.async {
                    self.processSuccess(dic: (value as? [String:Any]) ?? [:])
                }
            }, failHandler: { (error) in
                if let err = error {
                    DispatchQueue.main.async {
                        self.processError(error: err)
                    }
                }
            })
        }) {
         self.present(vc, animated: true, completion: nil)
        }
    }
    
    func processSuccess(dic:[String:Any]) {
        self.dismiss(animated: true, completion: nil)
        var words:String = ""
        if let words_result = dic["words_result"] as? [[String:Any]] {
            for item in words_result {
                if let word = item["words"] as? String {
                    words += word
                    words += "\n"
                }
            }
        }
        let vc = YKTextShowViewController()
        vc.setText(text: words)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func processError(error:Error) {
        self.dismiss(animated: true, completion: nil)
    }
}
