

import UIKit

@IBDesignable class PushButtonView: UIButton {

    @IBInspectable var fillColor:UIColor = UIColor.green
    @IBInspectable var isAddButton:Bool = true
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        let plusHeight:CGFloat = 3.0
        let plusWidth:CGFloat = min(bounds.width, bounds.height) * 0.6
        
        let plusPath = UIBezierPath()
        plusPath.lineWidth = plusHeight
        plusPath.move(to: CGPoint(x: bounds.width/2 - plusWidth/2 + 0.5, y: bounds.height/2 + 0.5))
        plusPath.addLine(to: CGPoint(x: bounds.width/2 + plusWidth/2 + 0.5, y: bounds.height/2 + 0.5))
        
        if isAddButton {
            plusPath.move(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 - plusWidth/2 + 0.5))
            plusPath.addLine(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 + 0.5 + plusWidth/2))
        }
        
        UIColor.white.setStroke()
        plusPath.stroke()
    }
    
    /// 旋转
    func onRotation(_ fromValue: CGFloat,_ toValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        // 初始值
        animation.fromValue = fromValue
        // 结束值
        animation.toValue = toValue
        // 动画执行时间
        animation.duration = 0.25
        // 动画重复执行次数
        animation.repeatCount = 0
        // 旋转后位置不还原
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: nil)
    }

}
