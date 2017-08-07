

import UIKit


/// 汇总报表
class SummaryReport {
    
    /// 支出总金额
    static var spendTotalMoney: Double!
    /// 支出总金额
    static var incomeTotalMoney: Double!
    
    /// 记账总月数
    static var monthCount: [AddModel]!
    
    /// 今天数据
    static var getTodayReport: [AddModel]!
    /// 本周数据
    static var getWeekReport: [AddModel]!
    /// 本月数据
    static var getMonthReport: [AddModel]!
    /// 本年数据
    static var getYearsReport: [AddModel]!
    
    /// 支出数据
    static var getSpendData: [AddModel]!
    /// 收入数据
    static var getIncomeData: [AddModel]!
    
    /// 支出类型数据
    static var spendTypeData: [TypeModel]!
    /// 收入类型数据
    static var incomeTypeData: [TypeModel]!
    
    
    class func getAllData() -> [AddModel] {
        let arr = AddModel.findAll() as! [AddModel]

        var spendArr: [AddModel] = []
        var incomeArr: [AddModel] = []
        var todayArr: [AddModel] = []
        var weekArr: [AddModel] = []
        var monthArr: [AddModel] = []
        var yearsArr: [AddModel] = []
        
        for i in arr {
            let time = i.time.doubleValue.date
            if i.addType == spend {
                spendArr.append(i)
            } else if i.addType == income {
                incomeArr.append(i)
            }
            if time.isThisYear {
                yearsArr.append(i)
                if time.isThisMonth {
                    monthArr.append(i)
                    if time.weekOrdinal == Date().weekOrdinal {
                        weekArr.append(i)
                    }
                    if time.isToday {
                        todayArr.append(i)
                    }
                }
            }
        }
        
        getSpendData(spendArr)
        getIncomeData(incomeArr)
        
        SummaryReport.getTodayReport = todayArr
        SummaryReport.getWeekReport = weekArr
        SummaryReport.getMonthReport = monthArr
        SummaryReport.getYearsReport = yearsArr
        
        return arr
    }
    
    static func getSpendData(_ data: [AddModel]) {
        var money = 0.0
        var monthCount:[AddModel] = []
        var spendData: [AddModel] = []
        
        for i in data {
            money += i.addMoney.doubleValue
            
            if i.addMoney == 0.0 {
                monthCount.append(i)
            } else {
                spendData.append(i)
            }
        }
        
        print("一共记了\(monthCount.count)个月")
        SummaryReport.getSpendData = spendData
        SummaryReport.spendTotalMoney = money
        SummaryReport.monthCount = monthCount
    }
    
    static func getIncomeData(_ data: [AddModel]) {
        var money = 0.0
        
        for i in data {
            money += i.addMoney.doubleValue
        }
       
        SummaryReport.getIncomeData = data
        SummaryReport.incomeTotalMoney = money
    }
    
    class func getTypeData() {
        SummaryReport.spendTypeData = TypeModel.find(byCriteria: "WHERE typeId = '\(spend)' ORDER BY \"pk\" DESC") as! [TypeModel]
        SummaryReport.incomeTypeData = TypeModel.find(byCriteria: "WHERE typeId = '\(income)' ORDER BY \"pk\" DESC") as! [TypeModel]
    }
    
}

