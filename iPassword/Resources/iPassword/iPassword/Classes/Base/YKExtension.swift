//
//  YKExtension.swift
//  iPassword
//
//  Created by 张元科 on 2018/7/1.
//  Copyright © 2018年 SDJG. All rights reserved.
//

import UIKit

extension UIColor {
    
    public final class func level(level: AnyObject) -> UIColor {
        let colorValue = NSString(string: "\(level)").intValue
        let colorText = colorValue <= 5 ? "6bbfff" : (colorValue <= 10 ? "fdb829" : "ff9865")
        return UIColor.extColorWithHex(colorText, alpha: 1)
    }
    
    
    public final class func extRGBA(red : CGFloat , green : CGFloat , blue : CGFloat , alpha : CGFloat)-> UIColor{
        
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        
    }
    
    public final class func extColorWithHex(_ hex : String, alpha:CGFloat) -> UIColor{
        var hexColor = hex
        
        hexColor = hexColor.replacingOccurrences(of: " ", with: "")
        if(hexColor.hasPrefix("#")){
            hexColor = String(hexColor.suffix(from: hexColor.index(hexColor.startIndex, offsetBy: 1)))
        }else{
            
        }
        let rStr = String(hexColor[hexColor.startIndex ..< hexColor.index(hexColor.startIndex, offsetBy: 2)])
        let gStr = String(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 2) ..< hexColor.index(hexColor.startIndex, offsetBy: 4)])
        let bStr = String(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 4) ..< hexColor.index(hexColor.startIndex, offsetBy: 6)])
        var r = uint()
        var g = uint()
        var b = uint()
        
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        
        let color : UIColor = UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        return color;
    }
    
}

