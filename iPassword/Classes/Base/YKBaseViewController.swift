//
//  YKBaseViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

class YKBaseViewController: UIViewController {

    var leftNavButtonImage:UIImage? = nil
    var leftNavButtonColor:UIColor = YKNaviBackArrowColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupNavBar()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        leftNavButtonImage = UIImage(named: "naviBack")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNavBar()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftNavButtonImage, style: UIBarButtonItemStyle.done, target: self, action: #selector(naviBarButtonClick))
        // 返回箭头颜色
        self.navigationItem.leftBarButtonItem?.tintColor = leftNavButtonColor
    }
    
    // 设置返回按钮颜色
    func setLeftBarColor(color:UIColor) {
        leftNavButtonColor = color
        self.navigationItem.leftBarButtonItem?.tintColor = color
    }
    
    // 隐藏导航栏返回按钮
    func hideNavLeftButton()
    {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    // 设置标题
    func setTitle(title:String) {
        self.navigationItem.title = title
    }
    // 设置点击关闭按钮为X
    func setCloseBackButton()
    {
        self.leftNavButtonImage  = UIImage(named: "naviClose")
    }
    
    @objc func naviBarButtonClick()
    {
        popBack()
    }
    
    @objc open func popBack() {
        if let vcs = self.navigationController?.viewControllers ,  vcs.count > 1 {
            self.navigationController!.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
