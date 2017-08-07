

import UIKit

@IBDesignable extension UIView {
    
    /// x坐标
    var x: CGFloat {
        return self.frame.origin.x
    }
    
    /// y坐标
    var y: CGFloat {
        return self.frame.origin.y
    }
    
    /// 中心点x坐标
    var centerX: CGFloat {
        return self.center.x
    }
    
    /// 中心点y坐标
    var centerY: CGFloat {
        return self.center.y
    }
    
    /// 宽度
    var width: CGFloat {
        return self.frame.size.width
    }
    
    /// 高度
    var height: CGFloat {
        return self.frame.size.height
    }
    
    /// 大小
    var size: CGSize {
        return self.frame.size
    }
    
    /// 右间距
    var rightSpacing: CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    /// 底部间距
    var bottomSpacing: CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    /// 设置x坐标
    func setX(_ x: CGFloat) {
        var rect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    /// 设置y坐标
    func setY(_ y: CGFloat) {
        var rect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    /// 设置x,y坐标
    func setXY(_ x: CGFloat, y: CGFloat) {
        var rect = self.frame
        rect.origin.x = x
        rect.origin.y = y
        self.frame = rect
    }
    
    /// 设置中心点x坐标
    func setCenterX(_ centerX: CGFloat) {
        var point = self.center
        point.x = centerX
        self.center = point
    }
    
    /// 设置中心点y坐标
    func setCenterY(_ centerY: CGFloat) {
        var point = self.center
        point.y = centerY
        self.center = point
    }
    
    /// 设置width
    func setWidth(_ width: CGFloat) {
        var rect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    /// 设置height
    func setHeight(_ height: CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
    /// 设置大小
    func setSize(_ size:CGSize) {
        var rect = self.frame
        rect.size = size
        self.frame = rect
    }
    
    /// setRight
    func setRight(_ right: CGFloat) {
        var rect = self.frame
        rect.origin.x = right - rect.size.width
        self.frame = rect
    }
    
    /// setBottom
    func setBottom(_ bottom: CGFloat) {
        var rect = self.frame
        rect.origin.y = bottom - rect.size.height
        self.frame = rect
    }
    
    /// 设置圆角
    func cornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// 设置阴影
    ///
    /// - parameter   color: 阴影颜色
    /// - parameter   offset: 阴影偏移，默认(0, -3),这个跟radius配合使用
    /// - parameter   radius: 阴影半径，默认3
    /// - parameter   opacity: 阴影透明度，默认0
    func shadow(_ color: UIColor, offset: CGSize?, radius: CGFloat?, opacity: Float?) {
        self.layer.shadowColor = color.cgColor
        if offset != nil {
            self.layer.shadowOffset = offset!
        }
        if radius != nil {
            self.layer.shadowRadius = radius!
        }
        if opacity != nil {
            self.layer.shadowOpacity = opacity!
        }
    }
    
    /// 设置边框和颜色
    func borderWidthAndColor(_ borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    /// showAlertView
    func showAlertView(_ title:String, message:String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: "好")
        alert.show()
    }
    
    /// 键盘弹起
    func viewScrollUP(_ dx: CGFloat,_ dy: CGFloat) {
        guard dy != 0 else {
            return
        }
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        self.frame.offsetBy(dx: dx, dy: dy)
        UIView.commitAnimations()
    }
    /// 键盘收回
    func viewScrollDonw() {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.3)
        self.frame = self.bounds
        UIView.commitAnimations()
    }
    
}
