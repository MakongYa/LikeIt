

import UIKit

class TimeSpaceCell: BaseTableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roundBtn: HeadIconView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        roundBtn.frame.size.width = 8
    }
    
    func setCell(_ model: AddModel) {
        dayLabel.text = model.time.stringValue.stringWithTimestamp("dd号")
        timeLabel.text = model.time.stringValue.date.weekday
    }

}
