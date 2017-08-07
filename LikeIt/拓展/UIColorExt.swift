

import UIKit

extension UIColor {
   
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static func RGB(_ cf: CGFloat...) -> UIColor {
        if cf.count > 3 {
            return UIColor()
        }
        return UIColor(red: cf[0]/255, green: cf[1]/255, blue: cf[2]/255, alpha: 1)
    }
}
