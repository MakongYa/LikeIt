

import UIKit

extension Date {
    
    /**
    获取时间戳
    
    - returns:  时间戳
    */
    var timeStamp:Double {
        return self.timeIntervalSince1970
    }
    
    /// 时间转String
    ///
    /// - parameter date: NSDate 时间
    /// - parameter format: String 时间格式
    /// - returns: 如："yyy年 MM月 dd日"
    func string(_ format: String) -> String {
        return dateFormat(format).string(from: self)
    }
    
   
    /// 设置时间样式
    ///
    /// - returns:  NSDateFormatter
    fileprivate func dateFormat(_ format:String) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        
        return fmt
    }
    
    /// 时间戳转Date
    ///
    /// - returns: 时间
//    func dateFromTimestamp(timeStamp: NSString) -> NSDate {
//        var date = NSDate(timeIntervalSince1970 : timeStamp.doubleValue)
//        
//        return  date.ymDate()
//    }

    /// 月份
    var monthday: String {
        var monthdays = ["一","二","三","四","五","六","七","八","九","十","十一","十二"]
        
        let calendarUnit = NSCalendar.Unit.month
        let comp = components(calendarUnit)
        
        return monthdays[comp.month!-1]
    }
    
    /// 星期
    var weekday: String {
        var weekdays = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        
        let calendarUnit = NSCalendar.Unit.weekday
        let comp = components(calendarUnit)
        
        return weekdays[comp.weekday!-1]
    }
    
    //  时间成分
    fileprivate func components(_ unit: NSCalendar.Unit) -> DateComponents {
        //创建日历
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "zh_CN")
        return (calendar as NSCalendar).components(unit, from: self)
    }
    
    /// 是否是今年
    var isThisYear: Bool {
        //取出给定时间的components
        let dateComponents = components(.year)
        //取出当前时间的components
        let nowComponents = Date().components(.year)
        
        return dateComponents == nowComponents
    }
    
    /// 是否是这个月
    var isThisMonth: Bool {
        //取出给定时间的components
        let dateComponents = components(.month)
        //取出当前时间的components
        let nowComponents = Date().components(.month)
        
        return isThisYear && (dateComponents == nowComponents)
    }
    
    /// 是否是这个星期
    var isThisWeek: Bool {
        let dateComponents = components(.weekday)
        let nowComponents = Date().components(.weekday)
        
        return isThisMonth && (dateComponents == nowComponents)
    }
    
    /// 是否是今天
    var isToday: Bool {
        let dateComponents = components(.day)
        let nowComponents = Date().components(.day)

        return isThisYear && isThisMonth && (dateComponents == nowComponents)
    }
    
    /// 第几周
    var weekOrdinal: Int {
        return self.components(.weekdayOrdinal).weekdayOrdinal!
    }
    
    ///  两个时间比较
    ///
    /// - parameter unit:     成分单元
    /// - parameter fromDate: 起点时间
    /// - parameter toDate:   终点时间
    /// - returns: 时间成分对象
    func dateComponents(_ unit: NSCalendar.Unit, fromDate: Date, toDate:Date) -> DateComponents {
        //创建日历
        let calendar = Calendar.current
        
        //直接计算
        let components = (calendar as NSCalendar).components(unit, from: fromDate, to: toDate, options: NSCalendar.Options.matchStrictly)
        
        return components
    }

    /// 计算时间两个顺序
    ///
    /// - parameter 时间A:
    /// - parameter 时间B:
    /// - returns: 1(A时间在B时间之后), -1(A时间在B时间之前), 0(A时间和B时间相同)
    func compareOneDay(_ oneDay: Date, otherDay: Date) -> Int {
        let oneDayStr = dateFormat("yyyy-MM-dd").string(from: oneDay)
        let otherDayStr = dateFormat("yyyy-MM-dd").string(from: otherDay)
        
        let dateA = dateFormat("yyyy-MM-dd").date(from: oneDayStr)
        let dateB = dateFormat("yyyy-MM-dd").date(from: otherDayStr)
        
        let result: ComparisonResult = dateA!.compare(dateB!)
        
        if (result == .orderedDescending) {
            NSLog("Date1 is in the future")
            return 1
        } else if (result == .orderedAscending) {
            NSLog("Date1 is in the past")
            return -1
        }
        NSLog("Both dates are the same")
        return 0
    }
    
}
