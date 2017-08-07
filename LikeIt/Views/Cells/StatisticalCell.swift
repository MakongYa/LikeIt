

import UIKit

protocol StatisticalCellDelegate {
    func didSelectView(_ type: Int)
}

class StatisticalCell: UITableViewCell {

    @IBOutlet weak var spendTotalMoneyBtn: UIButton!
    @IBOutlet weak var incomeTotalMoneyBtn: UIButton!
    @IBOutlet weak var spendTotalMoneyLabel: UICountingLabel!
    @IBOutlet weak var incomeTotalMoneyLabel: UICountingLabel!
    @IBOutlet weak var spendAverageView: UIView!
    @IBOutlet weak var incomeAverageView: UIView!
    @IBOutlet weak var spendAvgMoneyLabel: UICountingLabel!
    @IBOutlet weak var incomeAvgMoneyLabel: UICountingLabel!
    
    var delegate: StatisticalCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        spendTotalMoneyBtn.addTarget(self, action: #selector(StatisticalCell.onClickSpend), for: .touchUpInside)
        incomeTotalMoneyBtn.addTarget(self, action: #selector(StatisticalCell.onClickIncome), for: .touchUpInside)
    
        setCell()
    }
    
    func setCell() {
        let formatted = NumberFormatter()
        formatted.numberStyle = NumberFormatter.Style.decimal
        
        spendTotalMoneyLabel.method = UILabelCountingMethodEaseInOut
        spendTotalMoneyLabel.count(from: 0, to: SummaryReport.spendTotalMoney.float, withDuration: 0.6)
        spendTotalMoneyLabel.formatBlock = {(value: Float) -> String in
            
            return "¥\(formatted.string(from: NSNumber(value: value))!)"
        }
        
        incomeTotalMoneyLabel.method = UILabelCountingMethodEaseOut
        incomeTotalMoneyLabel.count(from: 0, to: SummaryReport.incomeTotalMoney.float, withDuration: 0.6)
        incomeTotalMoneyLabel.formatBlock = {(value: Float) -> String in
            
            return "¥\(formatted.string(from: NSNumber(value: value))!)"
        }
        
        var spendText = "", incomeText = ""
        if SummaryReport.monthCount.count == 0 {
            spendText  = "¥" + formatted.string(from: NSNumber(value: SummaryReport.spendTotalMoney!))!
            incomeText = "¥" + formatted.string(from: NSNumber(value: SummaryReport.incomeTotalMoney!))!
        } else {
            spendText  = "¥" + formatted.string(from: NSNumber(value: SummaryReport.spendTotalMoney / SummaryReport.monthCount.count.double))!
            incomeText = "¥" + formatted.string(from: NSNumber(value: SummaryReport.incomeTotalMoney / SummaryReport.monthCount.count.double))!
        }
        spendAvgMoneyLabel.text  = spendText
        incomeAvgMoneyLabel.text = incomeText
    }
    
    @objc fileprivate func onClickSpend() {
        delegate?.didSelectView(spend.intValue)
    }

    @objc fileprivate func onClickIncome() {
        delegate?.didSelectView(income.intValue)
    }
    
}
