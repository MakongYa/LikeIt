

import UIKit

class StatisticalDetailCell: UITableViewCell {

    @IBOutlet weak var typeImgView: UIImageView!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var addTimeLabel: UILabel!
    @IBOutlet weak var addMoneyLabel: UILabel!
    
    fileprivate var percentView: UIView!
    fileprivate var percent: Double!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        percentView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: contentView.height-1))
        percentView.backgroundColor = UIColor.groupTableViewBackground
        
        contentView.insertSubview(percentView, belowSubview: typeImgView)
    }

    func setCell(_ model: AddModel, isShowMonthInfo: Bool) {
        if model.addMoney.doubleValue > 0.0 {
            let typeModel = TypeModel.findFirst(byCriteria: "WHERE pk = '\(model.typePK)'")
            var totalMoney = 0.0
            
            if isShowMonthInfo {
                for i in SummaryReport.getMonthReport {
                    if i.addType == model.addType {
                        totalMoney += i.addMoney.doubleValue
                    }
                }
            } else {
                totalMoney = model.addType == spend ? SummaryReport.spendTotalMoney : SummaryReport.incomeTotalMoney
            }
            
            percent = model.addMoney.doubleValue / totalMoney
            
            UIView.animate(withDuration: 1.0, delay: 0.25, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.percentView.frame.size = CGSize(width:screenWidth * self.percent.cgFloat, height: self.contentView.height-1)
            }, completion: nil)
            
            typeImgView.image = UIImage(named: typeModel!.typePicName)
            typeNameLabel.text = typeModel?.typeTitle
            addTimeLabel.text = model.time.doubleValue.date.string("yyyy-MM-dd")
            addMoneyLabel.text = model.addMoney.stringValue
        }
    }

}
