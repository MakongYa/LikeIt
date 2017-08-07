

import UIKit

class TagButton: UIButton {

    //选中的颜色
    let colorSelectedTag = CustomColor.themeColor
    let colorTextUnSelectedTag = CustomColor.themeColor
    
    //未选中的颜色
    let colorUnselectedTag = UIColor.white
    let colorTextSelectedTag = UIColor.white
    
    var selectedBtn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setTitleColor(colorTextUnSelectedTag, for: UIControlState())
        self.borderWidthAndColor(1, borderColor: CustomColor.themeColor)
        self.cornerRadius(self.height/2)
        self.addTarget(self, action: #selector(TagButton.onClick(_:)), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onClick(_ sender: TagButton) {
        selectedBtn = !selectedBtn
        animateSelection()
    }
    
    fileprivate func animateSelection() {
        self.frame.size = CGSize(
            width: self.width - 5, height: self.height - 5)
        self.frame.origin = CGPoint(
            x: self.x + 5, y: self.y + 5)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            self.backgroundColor = self.selectedBtn ? self.colorSelectedTag : self.colorUnselectedTag
            self.setTitleColor(self.selectedBtn ? self.colorTextSelectedTag : self.colorTextUnSelectedTag, for: UIControlState())
            
            self.frame.size = CGSize(
                width: self.width + 5, height: self.height + 5)
            self.frame.origin = CGPoint(
                x: self.x - 5, y: self.y - 5)
            
            }, completion: nil)
    }

}
