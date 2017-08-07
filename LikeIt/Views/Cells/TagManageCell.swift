

import UIKit

class TagManageCell: UITableViewCell {

    @IBOutlet weak var typeImgView: UIImageView!
    @IBOutlet weak var typeNameLabel: UILabel!
    
    fileprivate var ponView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ponView = UIView(frame: CGRect(x: screenWidth-8-4, y: (contentView.height)/2, width: 4, height: 4))
        ponView.backgroundColor = UIColor.red
        ponView.cornerRadius(2)
        
        contentView.addSubview(ponView)
    }

    func setCell(_ model: TypeModel) {
        typeImgView.image = UIImage(named: model.typePicName)
        typeNameLabel.text = model.typeTitle
    }
    
    func showPon(_ isSys: Bool) {
        ponView.isHidden = isSys
    }

}
