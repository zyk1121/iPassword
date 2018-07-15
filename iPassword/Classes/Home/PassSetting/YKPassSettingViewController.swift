//
//  YKPassSettingViewController.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/15.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

class YKPassSettingViewController: YKBaseViewController {

    private let mainView = YKPassSettingMainView()
    private var documentController = UIDocumentInteractionController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "备份")
        setupUI()
        self.view.updateConstraintsIfNeeded()
    }
    
    func setupUI()
    {
        self.view.addSubview(mainView)
        mainView.parventVC = self
        mainView.setupEntity()
    }
    
    func toICloud()
    {
        let IPassFileName = "iPass.data"
        let homePath = NSHomeDirectory()
        let filePath = "\(homePath)/Documents/\(IPassFileName)"
        if (FileManager.default.fileExists(atPath: filePath)) {
           
            documentController = UIDocumentInteractionController.init(url: URL(fileURLWithPath: filePath))
            //        documentController.delegate = self
            //        documentController.UTI = "com.adobe.pdf"
            // public.data
            documentController.uti = "public.text" // public.data
            documentController.presentOpenInMenu(from: .zero, in: self.view, animated: true)
        } else {
             // 不存在
        }
    }
    
    func toITunes()
    {
        
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        mainView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}

class YKPassSettingMainView: UIView {
    
    public weak var parventVC:YKPassSettingViewController?
    public var dataSection:[String] = []
    public var dataArr:[[String]] = []
    
    public let mainTableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.extColorWithHex("ffffff", alpha: 1.0)
        tableView.register(YKPassSettingCell.classForCoder(), forCellReuseIdentifier: "YKPassSettingCell")
        return tableView
    }()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupData()
        setupUI()
        setNeedsUpdateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData()
    {
        dataSection = ["导出数据","导入数据"]
        let temp1 = ["导出数据至iTunes","备份数据到iCloud"]
        dataArr.append(temp1)
        let temp2 = ["从iTunes导入","从iCloud恢复数据"]
        dataArr.append(temp2)
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

extension YKPassSettingMainView:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < self.dataArr.count {
            let dataTemp = self.dataArr[section]
            return dataTemp.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YKPassSettingCell") as? YKPassSettingCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if indexPath.section < self.dataArr.count {
            let dataTemp = self.dataArr[indexPath.section]
            cell.packageNameLabel.text = dataTemp[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < self.dataSection.count {
            let entity = self.dataSection[section]
            let v = YKExerciseListSectionHeader(frame: CGRect.zero)
            v.label.text = entity
            return v
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 导出或导入数据
        switch indexPath.section {
        case 0:
            // 导出
            if indexPath.row == 0 {
                // 导出到iTunes
                self.parventVC?.toITunes()
            }
            if indexPath.row == 1 {
                // 导出到iCloud
                self.parventVC?.toICloud()
            }
        case 1:
            // 导入
            if indexPath.row == 0 {
                // 从iTunes导入
            }
            if indexPath.row == 1 {
                // 从iCloud导入
            }
        default:
            print("test")
        }
    }
}

class YKPassSettingCell: UITableViewCell {
    
    public let packageNameLabel:UILabel = {
        let label = UILabel()
        label.text = "设置"
        label.textColor = UIColor.extColorWithHex("3f9eff", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    public let rightImageView:UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "icon_more")
        return imv
    }()
    
    // init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setupUI()
        setNeedsUpdateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(packageNameLabel)
        self.addSubview(rightImageView)
    }
    
    func setupEntity() {
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        
        rightImageView.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.width.equalTo(5)
            make.height.equalTo(9)
            make.centerY.equalTo(self)
        }
        
        packageNameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
        }
        
        super.updateConstraints()
    }
}

class YKExerciseListSectionHeader:UIView {
    public let label:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.extColorWithHex("999999", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        self.backgroundColor = UIColor.extColorWithHex("f6f6f6", alpha: 1.0)
        updateConstraintsIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        label.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-15)
        }
        super.updateConstraints()
    }
}
