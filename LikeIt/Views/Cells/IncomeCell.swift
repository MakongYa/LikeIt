

import UIKit

class IncomeCell: BaseTableViewCell {

    @IBOutlet weak var spendTitleLabel: UILabel!
    @IBOutlet weak var spendMoneyLabel: UILabel!
    @IBOutlet weak var spendTypeBtn: DoneButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var delegate: AddCellDelegate?
    fileprivate var model: AddModel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        spendTypeBtn.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(IncomeCell.longRec(_:))))
        spendTypeBtn.addTarget(self, action: #selector(IncomeCell.onClick), for: .touchUpInside)
        updateUI()
    }
    
    fileprivate func updateUI() {
        spendTypeBtn.frame.origin.x = (screenWidth-spendTypeBtn.width) / 2
        self.updateConstraints()
        spendTypeBtn.setNeedsLayout()
        spendTypeBtn.layoutIfNeeded()
    }
    
    func setCell(_ model: AddModel) {
        self.model = model
        
        let typeModel = TypeModel.findFirst(byCriteria: "WHERE pk = '\(model.typePK)'")
        spendTitleLabel.text = typeModel?.typeTitle
        spendMoneyLabel.text = model.addMoney.stringValue
        spendTypeBtn.setImage(UIImage(named: (typeModel?.typePicName)!)!)
        timeLabel.text = model.addTime.stringValue.stringWithTimestamp("HH:mm")
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
