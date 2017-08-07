

import UIKit

class BaseTableViewCell: UITableViewCell {

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取画笔上下文
        let context = UIGraphicsGetCurrentContext()
        
        //抗锯齿设置
        context?.setAllowsAntialiasing(true)
        
        //画直线
        context?.setLineWidth(2) //设置画笔宽度
        context?.move(to: CGPoint(x: rect.width/2, y: -1))
        context?.addLine(to: CGPoint(x: rect.width/2, y: rect.height))
        context?.setStrokeColor(CustomColor.shadowColor.cgColor) //设置画笔颜色
        context?.strokePath()
    }

}
