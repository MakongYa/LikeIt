

import UIKit

extension String {
    
    
    /// 获取字符串Rect
    ///
    /// - parameter fontSize: 字体大小
    /// - parameter width: 显示的宽度
    /// - returns:  CGRect
    func stringRectWithFontSize(_ fontSize:CGFloat, width:CGFloat) -> CGRect {
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let  attributes = [
            NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()
        ]
        
        let text = self as NSString
        let rect = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context:nil)
        
        return rect
    }


    
    
    /// 时间戳转String
    ///
    /// - parameter  format: 时间格式
    /// - returns:   时间
    func stringWithTimestamp(_ format: String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        
        let date = Date(timeIntervalSince1970 : self.double!)
        
        return  fmt.string(from: date)
    }
    
    /**
    时间戳转几零后
    
    :returns:  "xx后"
    */
    func yStringWithTimestamp() -> String
    {
        let ts = NSString(string: self).doubleValue
        
        let date = Date(timeIntervalSince1970 : ts)
        let dateStr = dateFormat("yyyy年").string(from: date)
        return "\(NSString(string: dateStr).substring(with: NSMakeRange(2, 1)))0后"
    }
    
    /**
    几零后转时间戳
    
    :returns:  时间戳
    */
    func timestampWithYString() -> Int {
        let y = NSString(string: self).substring(with: NSMakeRange(0, 2))
        
        var yearStr: NSString!
        if y.substringToIndex(1) == "0" {
            yearStr = "20\(y)" as NSString
        } else {
            yearStr = "19\(y)" as NSString
        }
        
        let date = dateFormat("yyyy").date(from: "\(yearStr)")!
        let tamp: TimeInterval = date.timeIntervalSince1970
        
        return Int(tamp)
    }
    
    /**
    时间戳转时间
    
    :returns:  NSDate
    */
    var date: Date {
        let date = Date(timeIntervalSince1970: self.double!)
        
        return date
    }
    
    /**
    分隔字符串
    
    :returns:  分割后的字符串数组
    */
    func stringArrWithChar(_ char: String) -> [String] {
        return self.components(separatedBy: char)
    }
    
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
            let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
            
            CC_MD5(str!, strLen, result)
            
            let hash = NSMutableString()
            for i in 0..<digestLen {
                hash.appendFormat("%02x", result[i])
            }
            
            result.deinitialize()
            return String(format: hash as String).uppercased()
    }
    
    /// sql字符串
    var sqlString: String {
       return "'"+self+"'"
    }
    
    /// 判断是否是Number
    var isNumber: Bool {
        guard !self.isEmpty && (Int(self) != nil || Double(self) != nil) else {
            return false
        }
   
        return true
    }
    
    var double: Double? {
        guard !self.isEmpty && Double(self) != nil else {
            return nil
        }
        return Double(self)!
    }
    
    var float: Float? {
        guard !self.isEmpty && Float(self) != nil else {
            return nil
        }
        return Float(self)!
    }
    
    var int: Int? {
        guard !self.isEmpty && Int(self) != nil else {
            return nil
        }
        return Int(self)!
    }
    
    /// 计算长度
    var length: Int {
        return self.characters.count
    }
    
    
    
    /// 字符串去空格
    func subStringWhithSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    /// 字符串截取
    func substringToIndex(_ index:Int) -> String? {
        guard index > 0 else {
            return nil
        }
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: index))
    }
    /// 字符串截取
    func substringFromIndex(_ index:Int) -> String? {
        guard index > 0 else {
            return nil
        }
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
    }
    /// 字符串截取
    func substringWithRange(_ range:Range<Int>) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.characters.index(self.startIndex, offsetBy: range.upperBound)
        
        return self.substring(with: start..<end)
    }
    
    /// 字符串截取区间子字符串
    ///
    /// :param: 起始位置
    /// :param: 结束位置
    /// :returns: 子字符串
    func substringWithRange(_ startIndex: Int, endIndex: Int) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: endIndex)
        
        return self.substring(with: start..<end)
    }
//
//    subscript(index:Int) -> Character{
//        return self[advance(self.startIndex, index)]
//    }
//    
//    subscript(subRange:Range<Int>) -> String {
//        return self[advance(self.startIndex, subRange.startIndex)..<advance(self.startIndex, subRange.endIndex)]
//    }
//    
//    // MARK: - 字符串修改 RangeReplaceableCollectionType
//    mutating func insert(newElement: Character, atIndex i: Int) {
//        insert(newElement, atIndex: advance(self.startIndex,i))
//    }
//    
//    mutating func splice(newValues: String, atIndex i: Int) {
//        splice(newValues, atIndex: advance(self.startIndex,i))
//    }
//    
//    mutating func replaceRange(subRange: Range<Int>, with newValues: String) {
//        let start = advance(self.startIndex, subRange.startIndex)
//        let end = advance(self.startIndex, subRange.endIndex)
//        replaceRange(start..<end, with: newValues)
//    }
//    
//    mutating func removeAtIndex(i: Int) -> Character {
//        return removeAtIndex(advance(self.startIndex,i))
//    }
//    
//    mutating func removeRange(subRange: Range<Int>) {
//        let start = advance(self.startIndex, subRange.startIndex)
//        let end = advance(self.startIndex, subRange.endIndex)
//        removeRange(start..<end)
//    }
    
    func separatedByCharacters(_ separators: String) -> [String] {
        return self.components(separatedBy: CharacterSet(charactersIn: separators))
    }
    
    // MARK: - 字符替换
    /// 字符串替换字符
    ///
    /// :param: 旧字符
    /// :param: 新字符
    /// :returns: 新字符串
    func stringByReplacingOccurrencesOfString(_ oldCharacter: String, withCharacter: String) -> String {
        return self.replacingOccurrences(of: oldCharacter, with: withCharacter, options: .literal, range: nil)
    }
    
    /// 十六进制颜色 #
    var colorWithHexColorString: UIColor? {
        return self.colorWithHexColorString(self, alpha: 1.0)
    }
    
    /// 十六进制颜色  带alpha值
    func colorWithHexColorString(_ hexColorString: String, alpha: CGFloat) -> UIColor? {
        guard hexColorString.characters.count > 5 else {
            return nil
        }
        
        guard hexColorString.hasPrefix("0x") || hexColorString.hasPrefix("#") else {
            return nil
        }
        var cString: String!
        
        if hexColorString.hasPrefix("0x") {
            cString = hexColorString.substringFromIndex(2)
        } else if hexColorString.hasPrefix("#") {
            cString = hexColorString.substringFromIndex(1)
        }
        
        guard cString.characters.count == 6 else {
            return nil
        }
        
        //r
        let rString = cString.substringWithRange((0 ..< 2))
        
        //g
        let gString = cString.substringWithRange((2 ..< 4))
        
        //b
        let bString = cString.substringWithRange((4 ..< 6))
        
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        
        Scanner(string: rString).scanHexInt32(&red)
        Scanner(string: gString).scanHexInt32(&green)
        Scanner(string: bString).scanHexInt32(&blue)
        
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
    
    /// 设置时间样式
    ///
    /// - returns:  NSDateFormatter
    fileprivate func dateFormat(_ format:String) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        
        return fmt
    }

}
