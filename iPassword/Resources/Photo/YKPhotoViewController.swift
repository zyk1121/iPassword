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
    
    public let imageView:UIImageView = UIImageView()
    let pro = YKImageProcess()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavLeftButton()
        setTitle(title: "文字识别")
        
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        self.view.addSubview(imageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        test2()
    }
    
    func test2()
    {
        if let vc = AipGeneralVC.viewController(handler: { (image) in
            let options = ["language_type":"CHN_ENG","detect_direction":"true"]
            DispatchQueue.main.async {
                self.imageView.image = image
            }

            let img2 = self.pro.processRedLine(image!)
            AipOcrService.shard().detectText(from: image, withOptions: options, successHandler: { (value) in
                DispatchQueue.main.async {
                    self.imageView.image = img2;
                    self.processSuccess(dic: (value as? [String:Any]) ?? [:], isNeedRedLine: true)
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
    
    func test()
    {
        if let vc = AipGeneralVC.viewController(handler: { (image) in
            let options = ["language_type":"CHN_ENG","detect_direction":"true"]
            DispatchQueue.main.async {
                self.testtest(image: image)
            }
            
//            let pro = YKImageProcess()
//            let img = pro.processImageRecify(image!)
//            AipOcrService.shard().detectTextBasic(from: img, withOptions: options, successHandler: { (value) in
//                DispatchQueue.main.async {
//                    self.processSuccess(dic: (value as? [String:Any]) ?? [:])
//                }
//            }, failHandler: { (error) in
//                if let err = error {
//                    DispatchQueue.main.async {
//                        self.processError(error: err)
//                    }
//                }
//            })
        }) {
         self.present(vc, animated: true, completion: nil)
        }
    }
    
    func testtest(image:UIImage?) {
        self.dismiss(animated: true, completion: nil)
        self.imageView.image = image
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            let img = self.pro.processRedLine(image!)
            self.imageView.image = img
        }
    }
    
    func processSuccess(dic:[String:Any], isNeedRedLine:Bool = false) {
        self.dismiss(animated: true, completion: nil)
        var words:String = ""
        if let words_result = dic["words_result"] as? [[String:Any]] {
            for item in words_result {
                if let word = item["words"] as? String {
                    if (isNeedRedLine) {
                        if let loc = item["location"] as? [String:Any] {
                            let height = loc["height"] as? Int ?? 0
                            let left = loc["left"] as? Int ?? 0
                            let top = loc["top"] as? Int ?? 0
                            let width = loc["width"] as? Int ?? 0
                            var pt1 = CGPoint()
                            pt1.x = CGFloat(left);
                            pt1.y = CGFloat(top);
                            var pt2 = CGPoint()
                            pt2.x = CGFloat(left + width);
                            pt2.y = CGFloat(top + height);
                            if let wor = self.pro.processWords(word, pt1: pt1, pt2: pt2) {
                                if wor.count > 0 {
                                    words += wor
                                    words += "\n"
                                }
                            }
                            if let image = self.imageView.image {
//                                var pt3 = CGPoint()
//                                pt3.x = CGFloat(left);
//                                pt3.y = CGFloat(top + height - 5);
//
//                                var pt4 = CGPoint()
//                                pt4.x = CGFloat(left + width);
//                                pt4.y = CGFloat(top + height + 10);

                                let img = pro.drawRectangle(image, pt1: pt1, pt2: pt2)
                                self.imageView.image = img
                            }
                            
                        }
                    } else {
                        words += word
                        words += "\n"
                    }
                }
            }
        }
        print(words)
        /*
        let vc = YKTextShowViewController()
        vc.setText(text: words)
        self.navigationController?.pushViewController(vc, animated: true)
 */
    }
    
    func processError(error:Error) {
        self.dismiss(animated: true, completion: nil)
    }
}
