

import UIKit

extension Double {
    
    /// 时间
    var date:Date {
        let date = Date(timeIntervalSince1970: self)
        return date
    }
    
    var float:Float {
        return Float(self)
    }
    
    var string:String {
        return "\(self)"
    }
    
    var int:Int {
        return Int(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

extension Int {
    
    var float:Float {
        return Float(self)
    }
    
    var double:Double {
        return Double(self)
    }
    
    var string:String {
        return "\(self)"
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat {
    
    var int:Int {
        return Int(self)
    }
    
    var float:Float {
        return Float(self)
    }
    
    var double:Double {
        return Double(self)
    }
    
    var string:String {
        return "\(self)"
    }

}

extension Int32 {
    
    var int:Int {
        return Int(self)
    }
    
    var float:Float {
        return Float(self)
    }
    
    var double:Double {
        return Double(self)
    }
    
    var string:String {
        return "\(self)"
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
