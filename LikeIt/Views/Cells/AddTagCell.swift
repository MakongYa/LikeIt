

import UIKit

class AddTagCell: UICollectionViewCell {
    
    @IBOutlet weak var typeImgView: UIImageView!
    
    fileprivate var type:Int!
    
    func setCell(_ name: String, type: Int) {
        typeImgView.image = UIImage(named: name)
        
        self.type = type
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.cornerRadius(4)
        
        let bgView = UIView(frame: self.contentView.frame)
        bgView.backgroundColor = type == spend.intValue ? CustomColor.spendColor : CustomColor.inComeColor
        
        self.selectedBackgroundView = bgView
    }
}
