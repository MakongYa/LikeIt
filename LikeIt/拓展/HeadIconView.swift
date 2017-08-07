

import UIKit

@IBDesignable class HeadIconView: UIView {

    
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
    
    @IBInspectable var lineWidth:CGFloat = 0
    @IBInspectable var lineColor:UIColor = UIColor.white
    @IBInspectable var lineStartPoint:CGPoint = CGPoint(x: 0, y: 0)
    @IBInspectable var lineEndPoint:CGPoint = CGPoint(x: 0, y: 0)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取画笔上下文
        let context = UIGraphicsGetCurrentContext()
        
        //抗锯齿设置
        context?.setAllowsAntialiasing(true)
        
        //画直线
        context?.setLineWidth(lineWidth) //设置画笔宽度
        context?.move(to: CGPoint(x: lineStartPoint.x, y: lineStartPoint.y))
        context?.addLine(to: CGPoint(x: lineEndPoint.x, y: lineEndPoint.y))
        context?.setStrokeColor(lineColor.cgColor) //设置画笔颜色
        context?.strokePath()
    }
    
    func drawText(_ text: NSString, point: CGPoint) {
        text.draw(at: point, withAttributes: nil)
    }

//    func drawPoint() {
//        //画点
//        CGContextFillEllipseInRect(context, CGRectMake(75, 75, 50, 50))
//    }
    
//    func drawLine() {
//        //画直线
//        CGContextSetLineWidth(context, 5) //设置画笔宽度
//        CGContextMoveToPoint(context, 10, 20);
//        CGContextAddLineToPoint(context, 100, 100);
//        CGContextStrokePath(context)
//    }
//    func drawRang() {
//        //画圆
//        CGContextAddEllipseInRect(context, CGRectMake(50,50,100,100)); //画圆
//        CGContextStrokePath(context) //关闭路径
//        
//        //通过画弧画圆
//        //弧度=角度乘以π后再除以180
//        //角度=弧度除以π再乘以180
//        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor) //设置画笔颜色
//        CGContextAddArc(context, 100, 100, 50, 0, CGFloat(270*M_PI/180), 0) //画弧
//        CGContextStrokePath(context)//关闭路径
//    }

}
