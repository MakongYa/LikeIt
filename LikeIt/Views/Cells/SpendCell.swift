

import UIKit

protocol AddCellDelegate {
    func didSelectCell(_ model: AddModel?)
    func deleteCell(_ model: AddModel?)
}

class SpendCell: BaseTableViewCell {
    
    @IBOutlet weak var spendTitleLabel: UILabel!
    @IBOutlet weak var spendMoneyLabel: UILabel!
    @IBOutlet weak var spendTypeBtn: DoneButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var delegate: AddCellDelegate?
    fileprivate var model: AddModel!
    
    // UITableViewAutomaticDimension
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        spendTypeBtn.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(SpendCell.longRec(_:))))
        spendTypeBtn.addTarget(self, action: #selector(SpendCell.onClick), for: .touchUpInside)
        updateUI()
    }
    
    fileprivate func updateUI() {
        spendTypeBtn.frame.origin.x = (screenWidth-spendTypeBtn.width) / 2
        self.updateConstraints()
        spendTypeBtn.layoutIfNeeded()
    }
    
    func setCell(_ model: AddModel,_ isShowMonth: Bool) {
        if isShowMonth {
            spendTitleLabel.text = ""
            spendMoneyLabel.text = ""
            timeLabel.text = ""
            spendTypeBtn.setImage(UIImage(named: model.typePK)!)
        } else {
            self.model = model
            
            if let typeModel = TypeModel.findFirst(byCriteria: "WHERE pk = '\(model.typePK)'") {
                spendTitleLabel.text = typeModel.typeTitle
                spendMoneyLabel.text = model.addMoney.stringValue
                spendTypeBtn.setImage(UIImage(named: typeModel.typePicName)!)
                timeLabel.text = model.addTime.stringValue.stringWithTimestamp("HH:mm")
            }
        }
    }
    
    @objc fileprivate func onClick() {
        delegate?.didSelectCell(model)
    }
    
    @objc fileprivate func longRec(_ sender: UILongPressGestureRecognizer) {
        if sender.numberOfTouchesRequired == 1 {
            if sender.state == UIGestureRecognizerState.began {
                delegate?.deleteCell(model)
            }
        }
    }
    
}
