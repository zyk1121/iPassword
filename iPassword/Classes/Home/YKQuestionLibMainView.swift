//
//  YKQuestionLibMainView.swift
//  SDJGQuestionbankProject
//
//  Created by 张元科 on 2018/6/29.
//  Copyright © 2018年 王俊. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class YKQuestionLibMainView: UIView {
    
    public weak var questionLibVC:YKHomeViewController?
    
    public var dataArrs:[iPassSecureData] = []
    
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
    
    private let emptyView:YKSubjectEmptyView = YKSubjectEmptyView()
    
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
        mainTableView.addSubview(emptyView)
        emptyView.frame = CGRect(x: 0, y: 0, width: YK_ScreenWidth, height: 500)
        emptyView.isHidden = true
        emptyView.refreshBtn.addTarget(self, action: #selector(refreshButton(btn:)), for: .touchUpInside)
    }
    
    @objc func refreshButton(btn:UIButton) {
        
    }
    
    func setupEntity()
    {
        self.dataArrs.removeAll()
        if let arr = iPassSecure.shared().getAllData() {
            self.dataArrs.append(contentsOf: arr)
        }
        if self.dataArrs.count > 0 {
            self.emptyView.isHidden = true
        } else {
            self.emptyView.isHidden = false
        }
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

extension YKQuestionLibMainView:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 85
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
        
    }
}

// 课程空页面
class YKSubjectEmptyView:UIView {
    // 图片
    public let iconView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "empty")
        return view
    }()
    // 文字描述
    public let contentLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.extColorWithHex("888888", alpha: 1.0)
        label.text = "您还未添加任何账号哦~"
        label.numberOfLines = 0
        return label
    }()
    
    // 刷新按钮
    public let refreshBtn:UIButton = {
        let button = UIButton()
        button.setTitle("重新加载", for: .normal)
        button.setTitle("重新加载", for: .highlighted)
        button.setTitleColor(UIColor.extColorWithHex("cccccc", alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.extColorWithHex("ffffff", alpha: 1.0)
        setupUI()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(iconView)
        self.addSubview(contentLabel)
        self.addSubview(refreshBtn)
        refreshBtn.isHidden = true
    }
    
    // 布局
    override func updateConstraints() {
        let offset:CGFloat = 100
        iconView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(offset)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        contentLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(iconView.snp.bottom).offset(20)
        }
        refreshBtn.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
        }
        super.updateConstraints()
    }
}
