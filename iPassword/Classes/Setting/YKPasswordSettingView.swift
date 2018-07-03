//
//  YKPasswordSettingView.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/2.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import RxCocoa
import RxSwift

// 密码视图类型
enum YKPasswordSettingType:Int {
    case setting_step_one
    case setting_step_two
    case verify
    case touchid
    case change_step_one
    case change_step_two
}

// 全局的视图
private var kYKSettingPassView:YKPasswordSettingView? = nil
// YKMainIconColor
// 密码设置页面
class YKPasswordSettingView: UIView {
    
    var password:BehaviorRelay<String> = BehaviorRelay(value: "")
    let disposeBag:DisposeBag = DisposeBag()
    
    public let tipsLabel:UILabel = {
        let label = UILabel()
        label.text = "请输入密码"
        label.textColor = UIColor.extColorWithHex("333333", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private var dotVs:[YKDotView] = []
    private var numButtons:[YKNumberKeyButton] = []
    private var numZeroBtn:YKNumberKeyButton = YKNumberKeyButton()
    private var cancelBtn:YKNumberKeyButton = YKNumberKeyButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupUI()
        bindUI()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createDotView()->YKDotView {
        let v = YKDotView()
        v.layer.cornerRadius = 6
        v.clipsToBounds = true
        return v
    }
    
    private func createNumButton(value:String) -> YKNumberKeyButton {
        let btn = YKNumberKeyButton()
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(click(btn:)), for: .touchUpInside)
        btn.numLabel.text = value
        return btn
    }
    
    @objc func click(btn:UIButton) {
        if (btn.tag < 10 && btn.tag >= 0) {
            var val = password.value
            if (val.count < 6) {
                val.append("\(btn.tag)")
            }
            password.accept(val)
        } else {
            if (btn.tag == 10) {
                // 删除
                var val = password.value
                if (val.count > 0) {
                    val.removeLast()
                }
                password.accept(val)
            }
        }
    }
    
    func setupUI()
    {
        self.addSubview(tipsLabel)
        // 6个小点
        for _ in 0...5 {
            let v = createDotView()
            dotVs.append(v)
            self.addSubview(v)
        }
        // 11个按键
        for i in 1...9 {
            let v = createNumButton(value: "\(i)")
            v.tag = i
            numButtons.append(v)
            self.addSubview(v)
        }
        // 0
        numZeroBtn = createNumButton(value: "0")
        numZeroBtn.tag = 0
        numZeroBtn.numLabel.text = "0"
        numZeroBtn.clipsToBounds = true
        self.addSubview(numZeroBtn)
        // X
        cancelBtn = createNumButton(value: "X")
        cancelBtn.tag = 10
        cancelBtn.numLabel.text = "X"
        cancelBtn.clipsToBounds = true
        self.addSubview(cancelBtn)
    }
    
    var settingType:YKPasswordSettingType = .setting_step_one {
        didSet {
            changeState()
            setNeedsUpdateConstraints()
        }
    }
    
    func bindUI()
    {
        password.asObservable().subscribe {[weak self] (event) in
            self?.updateDotV(withPass: event.element ?? "")
        }.disposed(by: disposeBag)
    }
    
    // 刷新密码个数
    func updateDotV(withPass:String){
        let count = withPass.count
        for i in 0...(5) {
            dotVs[i].selected = false
        }
        if (count >= 1 && count <= 6) {
            for i in 0...(count-1) {
                dotVs[i].selected = true
            }
        }
    }
    
    func changeState()
    {
       
    }
    
    
    override func updateConstraints() {
        
        tipsLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(60)
        }
        
        let w = YK_ScreenWidth
        let dotW:CGFloat = 12
        let dotSpan:CGFloat = 15
        var startX = (w - (dotW * 6 + dotSpan * 5)) / 2
        var lastView:UIView = self
        for item in dotVs {
            item.snp.remakeConstraints { (make) in
                make.top.equalTo(tipsLabel.snp.bottom).offset(30)
                make.left.equalTo(self).offset(startX)
                make.width.height.equalTo(dotW)
            }
            startX += (dotW + dotSpan)
            lastView = item
        }
        
        // 按键
        var offsetY:CGFloat = 50
        let keySpan:CGFloat = 42
        let keyW:CGFloat = (w - keySpan * 4)/3
        startX = keySpan
        var index:Int = 0
        for item in numButtons {
            item.layer.cornerRadius = keyW / 2
            item.snp.remakeConstraints { (make) in
                make.left.equalTo(self).offset(startX)
                make.top.equalTo(lastView.snp.bottom).offset(offsetY)
                make.width.height.equalTo(keyW)
            }
            index += 1
            if (index % 3 == 0) {
                // 第三个
                startX = keySpan
                offsetY = keySpan - 12
                lastView = item
            } else {
                startX += (keySpan + keyW)
            }
        }
        // 0
        startX = keySpan + (keySpan + keyW)
        numZeroBtn.layer.cornerRadius = keyW / 2
        numZeroBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(startX)
            make.top.equalTo(lastView.snp.bottom).offset(offsetY)
            make.width.height.equalTo(keyW)
        }
        startX += (keySpan + keyW)
        // x
        cancelBtn.layer.cornerRadius = keyW / 2
        cancelBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(startX)
            make.top.equalTo(lastView.snp.bottom).offset(offsetY)
            make.width.height.equalTo(keyW)
        }
        super.updateConstraints()
    }
    
    public static func showPasswordSettingViewWith(type:YKPasswordSettingType) {
        if kYKSettingPassView != nil {
            kYKSettingPassView?.removeFromSuperview()
        }
        let passSettingView = YKPasswordSettingView(frame: UIScreen.main.bounds)
        passSettingView.settingType = type
        YK_KEY_WINDOW?.addSubview(passSettingView)
        kYKSettingPassView = passSettingView
    }
}

// 密码指示
class YKDotView: UIView {
    var selected:Bool = false {
        didSet {
            if selected {
                self.backgroundColor = YKMainIconColor
            } else {
                self.backgroundColor = UIColor.extColorWithHex("eeeeee", alpha: 1.0)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.extColorWithHex("eeeeee", alpha: 1.0)
    }
    
    override func updateConstraints() {
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 密码键盘
class YKNumberKeyButton: UIButton {
    
    public let numLabel:UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = UIColor.extColorWithHex("333333", alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.extColorWithHex("eeeeee", alpha: 1.0)
        self.setBackgroundImage(self.imageWithColor(YKMainIconColor), for: .highlighted)
        self.setBackgroundImage(self.imageWithColor(YKMainIconColor), for: .selected)
        self.setBackgroundImage(self.imageWithColor(UIColor.extColorWithHex("eeeeee", alpha: 1.0)), for: .normal)
        setupUI()
        setNeedsUpdateConstraints()
    }
    
    public final func imageWithColor(_ color : UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
    func setupUI()
    {
        self.addSubview(numLabel)
    }
    
    override func updateConstraints() {
        numLabel.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
