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
    public weak var maskView:UIView?
    public let imageView:UIImageView = UIImageView()
    private let mainView:YKPhotoMainView = YKPhotoMainView()
    let pro = YKImageProcess()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavLeftButton()
        setTitle(title: "文字识别")
        mainView.frame = CGRect(x: 0, y: 5, width: YK_ScreenWidth, height: 100)
        self.view.addSubview(mainView)
        mainView.parentVC = self
        mainView.setupEntity()
        imageView.frame = CGRect(x: 0, y: 105, width: YK_ScreenWidth, height: YK_ScreenWidth / 2 * 3)
        self.view.addSubview(imageView)
        imageView.isHidden = true
    }
    
    func showMaskView()
    {
        if maskView == nil {
            // maskView
            if let window = UIApplication.shared.keyWindow {
                let tempView = UIView()
                tempView.frame = UIScreen.main.bounds
                tempView.backgroundColor = UIColor.clear
                window.addSubview(tempView)
                maskView = tempView
            }
        }
    }
    
    func hideMaskView()
    {
        if maskView != nil {
            maskView?.removeFromSuperview()
        }
    }
    
    // 红下划线识别
    func redLineTextRecognize()
    {
        if let vc = AipGeneralVC.viewController(handler: { (image) in
            let options = ["language_type":"CHN_ENG","detect_direction":"true"]
            DispatchQueue.main.async {
                CBToast.showToast(message: "识别文字中，请稍后...", aLocationStr: "center", aShowTime: 1.5)
                // 添加遮罩
                self.showMaskView()
            }
            /*
            DispatchQueue.main.async {
                self.imageView.image = image
            }
             */
            // 红色下划线处理
            let imgTemp = self.pro.processRedLine(image!)
            AipOcrService.shard().detectText(from: image, withOptions: options, successHandler: { (value) in
                DispatchQueue.main.async {
                    // self.imageView.image = imgTemp;
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
    
    // 识别所有文字
    func commonTextRecognize()
    {
        if let vc = AipGeneralVC.viewController(handler: { (image) in
            DispatchQueue.main.async {
                 CBToast.showToast(message: "识别文字中，请稍后...", aLocationStr: "center", aShowTime: 1.5)
                // 添加遮罩
                self.showMaskView()
            }
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
    
//    func test_test(image:UIImage?) {
//        self.dismiss(animated: true, completion: nil)
//        self.imageView.image = image
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
//            let img = self.pro.processRedLine(image!)
//            self.imageView.image = img
//        }
//    }
    
    func processSuccess(dic:[String:Any], isNeedRedLine:Bool = false) {
        self.dismiss(animated: true, completion: nil)
        CBToast.hiddenToastAction()
        self.hideMaskView()
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
//                            if let image = self.imageView.image {
//                                let img = pro.drawRectangle(image, pt1: pt1, pt2: pt2)
//                                self.imageView.image = img
//                            }
                        }
                    } else {
                        words += word
                        words += "\n"
                    }
                }
            }
        }
        // 识别结果页面
        let vc = YKTextShowViewController()
        vc.setText(text: words)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func processError(error:Error) {
        self.dismiss(animated: true, completion: nil)
        CBToast.showToastAction(message: "识别文字失败了哦~")
        self.hideMaskView()
    }
}


// listView
class YKPhotoMainView: UIView {
    
    public weak var parentVC:YKPhotoViewController? = nil
    public var dataArrs:[String] = ["识别所有文字","识别红色下划线文字"]
    
    public let mainTableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.extColorWithHex("ffffff", alpha: 1.0)
        tableView.register(YKCourseTableViewCell.classForCoder(), forCellReuseIdentifier: "YKCourseTableViewCell")
        return tableView
    }()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupUI()
        setNeedsUpdateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        mainTableView.backgroundColor = UIColor.white
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.addSubview(mainTableView)
    }
    
    func setupEntity()
    {
        self.mainTableView.reloadData()
    }
    
    // 布局
    override public func updateConstraints() {
        
        mainTableView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        super.updateConstraints()
    }
}

extension YKPhotoMainView:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YKCourseTableViewCell") as? YKCourseTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setupEntity(data: self.dataArrs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 0) {
            self.parentVC?.commonTextRecognize()
        } else if (indexPath.row == 1) {
            self.parentVC?.redLineTextRecognize()
        }
    }
}
