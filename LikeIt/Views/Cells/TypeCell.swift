

import UIKit

class TypeCell: UICollectionViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cornerRadius(4)
        
        let bgView = UIView(frame: self.contentView.frame)
        bgView.backgroundColor = CustomColor.shadowOrangeColor
        
        self.selectedBackgroundView = bgView
    }
    
    func setCell(_ imageName: String, _ typeTitle: String) {
        typeImageView.image = UIImage(named: imageName)//UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("indexImage", ofType: "png")!)
        typeTitleLabel.text = typeTitle
    }

}
