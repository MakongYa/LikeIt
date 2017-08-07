

import UIKit

class StatisticalDetailHeadCell: UITableViewCell {

    @IBOutlet weak var addTypeImgView: UIImageView!
    @IBOutlet weak var addTypeTitleLabel: UILabel!
    

    func setCell(_ model: AddModel,isShowMonthInfo: Bool) {
        let isSpand = model.addType == spend
        let imgName = isSpand ? "支出" : "收入"
        addTypeImgView.image = UIImage(named: imgName)
        
        var text = ""
        if isShowMonthInfo {
            var money = 0.0
            
            for i in SummaryReport.getMonthReport {
                if i.addType == model.addType {
                    money += i.addMoney.doubleValue
                }
            }
            text = "¥ \(money)"
            
        } else {
            text = isSpand ? "¥ \(SummaryReport.spendTotalMoney)" : "¥ \(SummaryReport.incomeTotalMoney)"
        }
        addTypeTitleLabel.text = text
    }
    
}
