//
//  LLByteUntilTool.swift
//  toByteArr
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation
//十进制数转16进制字符串
func tenToSixtween(tenStr:String) -> String {
    let ten = UInt(tenStr)
    let sixStr = String(ten!, radix:16)
    return sixStr
}

//十进制转二进制
func tenToTwo(tenStr:String)->String{
    let ten = UInt(tenStr)
    let twoStr = String(ten!, radix:2)
    return twoStr
}


//16进制转十进制
func sixtweenToTen(sixStr:String)->String{
    let str = sixStr.uppercased()
    var sum = 0
    for i in str.utf8 {
        sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
        if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
            sum -= 7
        }
    }
    return String(sum)
}


//二进制转10进制
func binTodec(str:String)->String{
    var sum: Int = 0
    for c in str.characters {
        let str = String(c)
        sum = sum * 2 + Int(str)!
    }
    return String(sum)
}

//data转十六进制
func convertDataToHexStr(data:Data)->String{
    if  data.count == 0 {
        return ""
    }
    var str:String = ""
    data.enumerateBytes { (byte:UnsafeBufferPointer<UInt8>, index:Data.Index, isTrue:inout Bool) in
        let byteArr = byte
        for i in 0..<byteArr.count{
           let hexStr = "\(byteArr[i] & 0xff)"
           str.append(hexStr)
        }
    }
    return str
}




//字符串转data
func strToData(str:String)->Data{
    return str.data(using: String.Encoding.utf8)!
}

//数字不足位数左补零
func addzeroForNum(hexStr:String,strLength:Int)->String{
    let hex = hexStr as NSString
    let strLen = hex.length
    var newStr:String = ""
    for _ in 0..<(strLength - strLen){
        newStr = newStr.appending("0")
    }
    newStr.append(hexStr)
    return newStr
}

//十六进制字符串转byte
func hexStringToBytes(hexStr:String)->Array<UInt8>{
    if hexStr == "" || hexStr.lengthOfBytes(using: String.Encoding.utf8) == 0 {
        return []
    }
    
    let newStr = hexStr.uppercased().replacingOccurrences(of:" ", with:"")
    let length = newStr.lengthOfBytes(using: String.Encoding.utf8) / 2
    let charArr = newStr.cString(using: String.Encoding.utf8)
    var byteArr:Array<UInt8> = []
    for i in 0..<length{
        let pos = i * 2
        let item = UInt32.init(charToByte(c: (charArr?[pos])!) << 4 | charToByte(c: (charArr?[pos + 1])!))
        let byte = UInt8.init(item)
        byteArr.append(byte)
    }
    return byteArr
}

func charToByte(c:CChar)->UInt32{
    let charStr = "0123456789ABCDEF"
    let charArr = charStr.cString(using: String.Encoding.utf8)
    let a = charArr?.index(of:c)
    return UInt32.init(a!)
}

//倒序数组  高低位转换
func backwardsByteArr(arr:Array<UInt8>)->Array<UInt8>{
    let len = arr.count
    var result:Array<UInt8> = Array.init(repeating:0, count:len)
    for i in 0..<len {
        result[len - (1+i)] = arr[i]
    }
    return result
}

//获得日期时间组侦的形式 获得年月日时分秒
func getDateByte()->Array<UInt8>{
    var dataByteArr:Array<UInt8> = []
    let calendar = Calendar.current
    let comps = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
    let year = comps.year! % 2000 //取年的后两位
    let dateArr = [year,comps.month,comps.day,comps.hour,comps.minute,comps.second]
    for i in 0..<dateArr.count{
        let date:Int = dateArr[i]!
        let dateStr = String(date)
        let hexByte  = hexStringToBytes(hexStr:addzeroForNum(hexStr:dateStr, strLength:2))
        dataByteArr = dataByteArr + hexByte
    }
    return dataByteArr
}

//和校验
func getNumByte(bytes:Array<UInt8>)->UInt8{
    var byte:UInt16 = 0
    for item in bytes{
        byte = byte + UInt16.init(item)
    }
    return UInt8.init(byte%256)
}

//和校验
func getNumByte(bytes:ArraySlice<UInt8>)->UInt8{
    var byte:UInt16 = 0
    for item in bytes{
        byte = byte + UInt16.init(item)
    }
    return UInt8.init(byte%256)
}
