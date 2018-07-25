//
//  YKCourseTableViewCell.swift
//  SDJGQuestionbankProject
//
//  Created by 张元科 on 2018/7/2.
//  Copyright © 2018年 王俊. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum YKCourseCellType:Int {
    case normal = 0
    case firstCell = 1
    case empty  = 2
}

class YKCourseTableViewCell: UITableViewCell {
    
    private var cellType:YKCourseCellType = .normal
    
    public let packageNameLabel:UILabel = {
        let label = UILabel()
        label.text = "产品包名称"
        label.textColor = UIColor.extColorWithHex("3f9eff", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    public let iconImageView:UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "icon")
        return imv
    }()
    
    public let noCourseLabel:UILabel = {
        let label = UILabel()
        label.text = "暂无课程，请联系班主任哦。"
        label.textColor = UIColor.extColorWithHex("cccccc", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let courseContentVeiw:YKCourseContentView = YKCourseContentView()
    
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
        self.addSubview(iconImageView)
        self.addSubview(noCourseLabel)
        self.addSubview(courseContentVeiw)
    }
    
    func setupEntity(data:String,cellType:YKCourseCellType = .normal) {
        self.cellType = cellType
        courseContentVeiw.setupEntity(entity: data)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        
        courseContentVeiw.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(11)
            make.right.equalTo(self).offset(-11)
            make.bottom.equalTo(self).offset(-1)
            make.height.equalTo(50)
        }
        
        if self.cellType == .firstCell || self.cellType == .empty {
            iconImageView.isHidden = false
            packageNameLabel.isHidden = false
            iconImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(self).offset(15)
                make.centerY.equalTo(packageNameLabel)
                make.width.height.equalTo(7)
            }
            
            packageNameLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(iconImageView.snp.right).offset(8)
                make.top.equalTo(self).offset(15)
                make.right.equalTo(self).offset(-15)
            }
            
            noCourseLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(packageNameLabel.snp.bottom).offset(30)
                make.left.equalTo(self).offset(97)
            }
            
            if (self.cellType == .empty) {
                noCourseLabel.isHidden = false
                courseContentVeiw.isHidden = true
            } else {
                noCourseLabel.isHidden = true
                courseContentVeiw.isHidden = false
            }
        } else {
            iconImageView.isHidden = true
            packageNameLabel.isHidden = true
            noCourseLabel.isHidden = true
            courseContentVeiw.isHidden = false
        }
        
        super.updateConstraints()
    }
}

// 课程名称和进度
class YKCourseContentView:UIView {
    
    private let bgImageView:UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "bg_list")
        return imv
    }()
    
    public let courseNameLabel:UILabel = {
        let label = UILabel()
        label.text = "课程名称"
        label.textColor = UIColor.extColorWithHex("323232", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    public let progressLabel:UILabel = {
        let label = UILabel()
        label.text = "做题进度：12/300"
        label.textColor = UIColor.extColorWithHex("aaaaaa", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    public let rightImageView:UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "icon_more")
        return imv
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
        self.addSubview(bgImageView)
        self.addSubview(courseNameLabel)
        self.addSubview(progressLabel)
        self.addSubview(rightImageView)
    }
    
    func setupEntity(entity:String) {
        courseNameLabel.text = entity
        progressLabel.text = entity
        progressLabel.isHidden = true
    }
    
    override func updateConstraints() {
        
        bgImageView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self)
        }
        rightImageView.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.width.equalTo(5)
            make.height.equalTo(9)
            make.centerY.equalTo(self)
        }
        courseNameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(18 )
            make.right.equalTo(rightImageView.snp.left).offset(-15 )
            make.centerY.equalTo(self)
        }
        progressLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(18)
            make.bottom.equalTo(self).offset(-20)
            make.right.equalTo(courseNameLabel)
        }
        super.updateConstraints()
    }
}
