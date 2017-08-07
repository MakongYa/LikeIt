

import UIKit

protocol ChartCellDelegate {
    func didSelectChart(_ model: AddModel)
    func showTypeInfo(_ type: Int)
}

class ChartCell: UITableViewCell, UIScrollViewDelegate, PNChartDelegate {
    
    @IBOutlet weak var _scrollView: UIScrollView!
    
    fileprivate var cellHeight = screenHeight - 206 - 65 - 49
    fileprivate let chartY: CGFloat = IS_IPHONE_4_4s ? 26 : 30
    fileprivate var chartHeight: CGFloat!
    
    fileprivate var todayChart: PNPieChart!
    fileprivate var weekChart: PNBarChart!
    fileprivate var monthChart: UIView!
    fileprivate var yearsChart: PNLineChart!
    
    var delegate: ChartCellDelegate?
    fileprivate var page = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartHeight = IS_IPHONE_4_4s ? 130 : (IS_IPHONE_6P ? 350 : (IS_IPHONE_6 ? 300 : 200))
        
        _scrollView.contentSize = CGSize(width: 4 * screenWidth, height: cellHeight)
        _scrollView.delegate = self
        
        for i in 0..<4 {
            let label = UILabel(frame: CGRect(x: CGFloat(i) * screenWidth + (screenWidth-200)/2, y: 5, width: 200, height: 20))
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.text = ["今日明细","本周详情(第\(Date().weekOrdinal)周)","\(Date().monthday)月账单","本年走势"][i]
            
            _scrollView.addSubview(label)
        }
        setCell()
    }
    
    func setCell() {
        removeTodayChart()
        _scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        creatTodayChart()
    }
    
    /// 今日明细
    fileprivate func creatTodayChart() {
        var frame: CGRect!
        
        if IS_IPHONE_4_4s {
            frame = CGRect(x: (screenWidth-130)/2, y: chartY, width: 130, height: chartHeight)
        } else if IS_IPHONE_5 {
            frame = CGRect(x: (screenWidth-200)/2, y: chartY, width: 200, height: chartHeight)
        } else {
            frame = CGRect(x: (screenWidth-300)/2, y: chartY, width: 300, height: chartHeight)
        }
        
        var items: [PNPieChartDataItem] = []
        
        if SummaryReport.getTodayReport.count == 0 {
            let item = PNPieChartDataItem(value: 0, color: CustomColor.lightGreen, description: "今天还没有记账")
            items.append(item!)
        } else {
            var totalMoney = 0.0
            for i in SummaryReport.getTodayReport {
                totalMoney += i.addMoney.doubleValue
            }
            
            for i in 0..<SummaryReport.getTodayReport.count {
                let model = SummaryReport.getTodayReport[i]
                guard model.addMoney.doubleValue > 0.0 else {
                    continue
                }
                let typeModel = TypeModel.findFirst(byCriteria: "WHERE pk = '\(model.typePK)'")
                
                let item = PNPieChartDataItem(value: CGFloat(model.addMoney.doubleValue/totalMoney), color: colorArr[i], description: typeModel!.typeTitle)
                                
                items.append(item!)
            }
        }
        
        todayChart = PNPieChart(frame: frame, items: items)
        
        todayChart.descriptionTextColor = UIColor.white
        todayChart.descriptionTextFont  = UIFont(name: "Avenir-Medium", size: IS_IPHONE_4_4s ? 11 : 14)
        todayChart.descriptionTextShadowColor = UIColor.clear
        todayChart.showAbsoluteValues = false
        todayChart.showOnlyValues = false
        todayChart.delegate = self
        
        todayChart.stroke()
        
        todayChart.legendStyle = PNLegendItemStyle.stacked
        todayChart.legendFont = UIFont.boldSystemFont(ofSize: 12)
        todayChart.legendFontColor = CustomColor.lightGreen
        
        _scrollView.addSubview(todayChart)
    }
    
    /// 本周详情
    fileprivate func creatWeekChart() {
        let barChartFormatter = NumberFormatter()
        barChartFormatter.numberStyle = NumberFormatter.Style.currency
        barChartFormatter.allowsFloats = false
        barChartFormatter.maximumFractionDigits = 0
        
        weekChart = PNBarChart(frame: CGRect(x: screenWidth, y: chartY, width: screenWidth, height: chartHeight))
        weekChart.backgroundColor = UIColor.clear
        weekChart.yLabelFormatter = {(value: CGFloat) -> String in
            return barChartFormatter.string(from: NSNumber(value: value.double))!
        }
        
        weekChart.yChartLabelWidth = 0
        weekChart.chartMarginLeft = 8
        weekChart.chartMarginRight = 5
        weekChart.chartMarginTop = 8
        weekChart.chartMarginBottom = 0
        weekChart.labelMarginTop = 5
        weekChart.showChartBorder = false
        weekChart.isGradientShow = false
        weekChart.isShowNumbers = false
        
        weekChart.strokeColors = [
            CustomColor.spendColor,
            CustomColor.themeColor,
            PNYellow,
            CustomColor.green,
            CustomColor.diabloBlackFontColor,
            PNBlue,
            PNPinkGrey
        ]
        
        weekChart.delegate = self
        weekChart.xLabels = ["周日","周一","周二","周三","周四","周五","周六"]
        
        var data = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        var money0 = 0.0,money1 = 0.0,money2 = 0.0,money3 = 0.0,money4 = 0.0,money5 = 0.0,money6 = 0.0
        
        for i in SummaryReport.getWeekReport {
            switch i.time.doubleValue.date.weekday {
            case "星期日":
                money0 += i.addMoney.doubleValue
                data[0] = money0
            case "星期一":
                money1 += i.addMoney.doubleValue
                data[1] = money1
            case "星期二":
                money2 += i.addMoney.doubleValue
                data[2] = money2
            case "星期三":
                money3 += i.addMoney.doubleValue
                data[3] = money3
            case "星期四":
                money4 += i.addMoney.doubleValue
                data[4] = money4
            case "星期五":
                money5 += i.addMoney.doubleValue
                data[5] = money5
            case "星期六":
                money6 += i.addMoney.doubleValue
                data[6] = money6
            default :break
            }
        }
        weekChart.yValues = data
        
        weekChart.stroke()
        _scrollView.addSubview(weekChart)
    }
    
    /// 本月账单
    fileprivate func creatMonthChart() {
        monthChart = UIView(frame: CGRect(x: 2 * screenWidth, y: chartY, width: screenWidth, height: chartHeight))
        monthChart.backgroundColor = UIColor.clear
        
        var spendMoney  = 0.0
        var incomeMoney = 0.0
        
        for i in SummaryReport.getMonthReport {
            if i.addType == spend {
                spendMoney += i.addMoney.doubleValue
            } else {
                incomeMoney += i.addMoney.doubleValue
            }
        }
        
        let lY = (monthChart.height/2 - 20) / 2
        let bY = (monthChart.height/2 - 35) / 2
        
        let lSpendTitle = UILabel(frame: CGRect(x: (monthChart.width-200)/2, y: lY, width: 200, height: 20))
        lSpendTitle.text = "支出 － \(spendMoney)元"
        lSpendTitle.textColor = UIColor.white
        
        let bSpendInfo = UIButton(type: UIButtonType.infoLight)
        bSpendInfo.frame = CGRect(x: (monthChart.width-20-35), y: bY, width: 35, height: 35)
        bSpendInfo.addTarget(self, action: #selector(ChartCell.onClick(_:)), for: .touchUpInside)
        bSpendInfo.tag = 100
        
        let lineView = UIView(frame: CGRect(x: 10, y: monthChart.height/2, width: monthChart.width-20, height: 0.5))
        lineView.backgroundColor = RGB(219,138,98)
        
        let lIncomeTitle = UILabel(frame: CGRect(x: (monthChart.width-200)/2, y: monthChart.height/2 + lY, width: 200, height: 20))
        lIncomeTitle.text = "收入 － \(incomeMoney)元"
        lIncomeTitle.textColor = UIColor.white
        
        let bIncomeInfo = UIButton(type: UIButtonType.infoLight)
        bIncomeInfo.frame = CGRect(x: (monthChart.width-20-35), y: monthChart.height/2 + bY, width: 35, height: 35)
        bIncomeInfo.addTarget(self, action: #selector(ChartCell.onClick(_:)), for: .touchUpInside)
        bIncomeInfo.tag = 101
        
        monthChart.addSubview(lSpendTitle)
        monthChart.addSubview(bSpendInfo)
        monthChart.addSubview(lineView)
        monthChart.addSubview(lIncomeTitle)
        monthChart.addSubview(bIncomeInfo)
        _scrollView.addSubview(monthChart)
    }
    
    /// 本年走势
    fileprivate func creatYearsChart() {
        yearsChart = PNLineChart(frame: CGRect(x: 3 * screenWidth - 30, y: chartY, width: screenWidth + 30, height: cellHeight - 25))
        yearsChart.showLabel = true
        yearsChart.backgroundColor = UIColor.clear
        yearsChart.xLabels = ["1月","2","3","4","5","6","7","8","9","10","11","12"]
        yearsChart.isShowCoordinateAxis = true
        yearsChart.yFixedValueMin = 10
        yearsChart.showGenYLabels = false
        
        
        
        // Line Chart Nr.1
        var data01Array = yearData(SummaryReport.getSpendData) as! [Double]
        
        let data01 = PNLineChartData()
        data01.color = CustomColor.spendColor
        data01.itemCount = UInt(data01Array.count)
        data01.inflexionPointStyle = PNLineChartPointStyle.circle
        data01.getData = ({(index: UInt) -> PNLineChartDataItem in
            let yValue = data01Array[Int(index)]
            let item = PNLineChartDataItem(y: CGFloat(yValue))
            return item!
        })
        
        // Line Chart Nr.2
        var data02Array = yearData(SummaryReport.getIncomeData) as! [Double]
        let data02 = PNLineChartData()
        data02.color = CustomColor.inComeColor
        data02.itemCount = UInt(data02Array.count)
        data02.inflexionPointStyle = PNLineChartPointStyle.circle
        data02.getData = ({(index: UInt) -> PNLineChartDataItem in
            let yValue = data02Array[Int(index)]
            let item = PNLineChartDataItem(y: CGFloat(yValue))
            return item!
        })
        
        yearsChart.chartData = [data01, data02]
        
        yearsChart.stroke()
        _scrollView.addSubview(yearsChart)
    }
    
    fileprivate func yearData(_ data: [AddModel]) -> NSArray {
        var arr = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        var money1=0.0,money2=0.0,money3=0.0,money4=0.0,money5=0.0,money6=0.0,money7=0.0,money8=0.0,money9=0.0,money10=0.0,money11=0.0,money12=0.0
        for i in data {
            switch i.time.doubleValue.date.monthday {
            case "一":
                money1 += i.addMoney.doubleValue
                arr[0] = money1
            case "二":
                money2 += i.addMoney.doubleValue
                arr[1] = money2
            case "三":
                money3 += i.addMoney.doubleValue
                arr[2] = money3
            case "四":
                money4 += i.addMoney.doubleValue
                arr[3] = money4
            case "五":
                money5 += i.addMoney.doubleValue
                arr[4] = money5
            case "六":
                money6 += i.addMoney.doubleValue
                arr[5] = money6
            case "七":
                money7 += i.addMoney.doubleValue
                arr[6] = money7
            case "八":
                money8 += i.addMoney.doubleValue
                arr[7] = money8
            case "九":
                money9 += i.addMoney.doubleValue
                arr[8] = money9
            case "十":
                money10 += i.addMoney.doubleValue
                arr[9] = money10
            case "十一":
                money11 += i.addMoney.doubleValue
                arr[10] = money11
            case "十二":
                money12 += i.addMoney.doubleValue
                arr[11] = money12
            default: break
            }
        }
        return arr as NSArray
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        
        if offsetX == 0 {
            if page != 1 {
                page = 1
                creatTodayChart()
                removeWeekChart()
            }
        } else if offsetX == screenWidth {
            if page != 2 {
                page = 2
                creatWeekChart()
                removeTodayChart()
                removeTodayChart()
                removeMonthChart()
            }
        } else if offsetX == (2 * screenWidth) {
            if page != 3 {
                page = 3
                creatMonthChart()
                removeTodayChart()
                removeWeekChart()
                removeYearsChart()
            }
        } else if offsetX == (3 * screenWidth) {
            if page != 4 {
                page = 4
                creatYearsChart()
                removeMonthChart()
            }
        }
    }
    
    func removeAllChart() {
        removeTodayChart()
        removeWeekChart()
        removeMonthChart()
        removeYearsChart()
    }
    func removeTodayChart() {
        if todayChart != nil {
            todayChart.removeFromSuperview()
            todayChart = nil
        }
    }
    func removeWeekChart() {
        if weekChart != nil {
            weekChart.removeFromSuperview()
            weekChart = nil
        }
    }
    func removeMonthChart() {
        if monthChart != nil {
            monthChart.removeFromSuperview()
            monthChart = nil
        }
    }
    func removeYearsChart() {
        if yearsChart != nil {
            yearsChart.removeFromSuperview()
            yearsChart = nil
        }
    }
    
    @objc fileprivate func onClick(_ sender: UIButton) {
        delegate?.showTypeInfo(sender.tag-100)
    }
    
    func userClickedOnBar(at barIndex: Int) {
        print(barIndex)
    }
    func userClicked(onLineKeyPoint point: CGPoint, lineIndex: Int, pointIndex: Int) {
        print("point\(point),lineIndex\(lineIndex)")
    }
    func userClicked(onLinePoint point: CGPoint, lineIndex: Int) {
        print("point\(point),lineIndex\(lineIndex)")
    }
    func userClicked(onPieIndexItem pieIndex: Int) {
        print("pieIndex\(pieIndex)")
        
        guard SummaryReport.getTodayReport.count > 0 else {
            return
        }
        let model = SummaryReport.getTodayReport[pieIndex]
        
        delegate?.didSelectChart(model)
        print(model)
    }
    func didUnselectPieItem() {
        print("didUnselectPieItem")
    }
    
}
