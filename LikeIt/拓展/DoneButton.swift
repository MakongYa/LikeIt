

import UIKit

@IBDesignable class DoneButton: UIButton {

    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }


    func isDone(_ bol: Bool) {
        if bol {
            self.backgroundColor = UIColor(red: 38/255, green: 146/255, blue: 42/255, alpha: 1)
            self.setTitleColor(UIColor.white, for: UIControlState())
            self.isEnabled = true
        } else {
            self.backgroundColor = UIColor.groupTableViewBackground
            self.setTitleColor(UIColor.darkGray, for: UIControlState())
            self.isEnabled = false
        }
    }
    
}
