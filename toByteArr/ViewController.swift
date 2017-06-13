//
//  ViewController.swift
//  toByteArr
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tf:UITextField?
    var lb:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewW = self.view.frame.size.width
        tf = UITextField.init(frame: CGRect(x:25, y:64, width:viewW-50, height:50))
        tf?.layer.borderWidth = 0.5
        tf?.layer.borderColor = UIColor.blue.cgColor
        if #available(iOS 10.0, *) {
            tf?.keyboardType = UIKeyboardType.asciiCapableNumberPad
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(tf!)
        
        let arTitle = ["2转10","10转16","16转10","16转byte","data转16","str转data"]
        var maxY:CGFloat = (tf?.frame.maxY)!
        for i in 0..<arTitle.count{
            let spaceX:CGFloat = 25
            let spaceY:CGFloat = 25
            let btnW = (viewW - spaceX * 4)/3
            let btnH:CGFloat = 35
            let btnRt = CGRect(x:spaceX + (btnW + spaceX) * CGFloat(i%3),
                               y: (tf?.frame.maxY)! + spaceY + (spaceY + btnH) * CGFloat(i/3), width:btnW, height:btnH)
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.frame = btnRt
            btn.setTitle(arTitle[i], for: UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.layer.borderColor = UIColor.gray.cgColor
            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            btn.tag = i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(btn)
            maxY = btnRt.maxY
        }
        lb = UILabel.init(frame: CGRect(x:25, y:maxY+10, width:viewW-50, height:20))
        self.view.addSubview(lb!)
        
    }
    
    
    func btnClick(btn:UIButton) {
        if tf?.text?.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            print("请先输入要转换的内容")
            return
        }
       
        if btn.titleLabel?.text == "16转10"{
           lb?.text = sixtweenToTen(sixStr:(tf?.text)!)
        }else if btn.titleLabel?.text == "10转16"{
            lb?.text = tenToSixtween(tenStr:(tf?.text)!)
        }else if btn.titleLabel?.text == "2转10"{
            lb?.text = binTodec(str:(tf?.text)!)
        }else if btn.titleLabel?.text == "16转byte"{
            lb?.text =  String(describing: hexStringToBytes(hexStr:(tf?.text)!))
        }else if btn.titleLabel?.text == "data转16"{
            lb?.text = convertDataToHexStr(data:(tf?.text?.data(using: String.Encoding.utf8))!)
        }else if btn.titleLabel?.text == "str转data"{
            lb?.text = String(describing: strToData(str:(tf?.text)!))
                //String(data:strToData(str:(tf?.text)!), encoding: String.Encoding.utf8)
        }
    }

}

