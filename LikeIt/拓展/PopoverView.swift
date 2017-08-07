

import UIKit

class PopoverView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let ROW_HEIGHT:CGFloat = 44
    fileprivate let SPACE:CGFloat = 2
    fileprivate let kArrowHeight:CGFloat = 10
    fileprivate let kArrowCurvature:CGFloat = 6
    
    fileprivate var _tableView: UITableView!
    fileprivate var titleArray: NSArray!
    fileprivate var imageArray: NSArray!
    fileprivate var showPoint: CGPoint!
    
    fileprivate var handerView: UIButton!
    var selectRowAtIndex: (Int) -> () = {param in }

    fileprivate var borderColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        borderColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1)
    }
    
    convenience init(point: CGPoint, titles: NSArray, images: NSArray?) {
        self.init()
        self.showPoint = point
        self.titleArray = titles
        self.imageArray = images
        self.frame = getViewFrame()
        self.addSubview(tableView())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        handerView = UIButton(frame: UIScreen.main.bounds)
        handerView.backgroundColor = UIColor.clear
        handerView.addTarget(self, action: #selector(PopoverView.dismiss as (PopoverView) -> () -> ()), for: UIControlEvents.touchUpInside)
        handerView.addSubview(self)
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(handerView)
        
        let arrowPoint = self.convert(showPoint, from: handerView)
        
        self.layer.anchorPoint = CGPoint(x: arrowPoint.x / self.frame.size.width, y: arrowPoint.y / self.frame.size.height)
        self.frame = getViewFrame()
        
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.alpha = 1.0
        }, completion: { (finished) -> Void in
            self.transform = CGAffineTransform.identity
            self.isUserInteractionEnabled = true
        }) 
    }
    
    func dismiss() {
        dismiss(true)
    }
    
    fileprivate func dismiss(_ animated: Bool) {
        if !animated {
            handerView.removeFromSuperview()
            return
        }
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0
        }, completion: { (finished) -> Void in
            self.handerView.removeFromSuperview()
            self.isUserInteractionEnabled = true
        }) 
    }
    
    fileprivate func getViewFrame() -> CGRect {
        var frame = CGRect.zero
        frame.size.height = (CGFloat(titleArray.count) * ROW_HEIGHT) + SPACE + kArrowHeight
        
        for title in titleArray {
            let width = stringRectWithFontSize(title as! String, fontSize: 15, width: 1000).width
            frame.size.width = max(width, frame.size.width)
        }
        
        if imageArray != nil && titleArray.count == imageArray.count {
            frame.size.width = 8 + 25 + 8 + frame.size.width + 30
        } else {
            frame.size.width = 8 + frame.size.width + 30
        }
        
        frame.origin.x = self.showPoint.x - frame.size.width/2
        frame.origin.y = self.showPoint.y
        
        //左间隔最小5x
        if (frame.origin.x < 5) {
            frame.origin.x = 5
        }
        //右间隔最小5x
        if ((frame.origin.x + frame.size.width) > 315) {
            frame.origin.x = 315 - frame.size.width
        }
        
        return frame
    }
    
    fileprivate func tableView() -> UITableView {
        if _tableView != nil {
            return _tableView
        }
        
        var rect = self.frame
        rect.origin.x = SPACE
        rect.origin.y = kArrowHeight + SPACE
        
        rect.size.width -= SPACE * 2
        rect.size.height -= (SPACE - kArrowHeight)
        
        _tableView = UITableView(frame:rect, style:UITableViewStyle.plain)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        _tableView.alwaysBounceHorizontal = false
        _tableView.alwaysBounceVertical = false
        _tableView.showsHorizontalScrollIndicator = false
        _tableView.showsVerticalScrollIndicator = false
        _tableView.isScrollEnabled = false
        _tableView.backgroundColor = UIColor.clear
        return _tableView;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.backgroundView = UIView()
        cell?.backgroundView?.backgroundColor = RGB(245,245,245)
        
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.text = titleArray.object(at: indexPath.row) as? String
//        cell?.textLabel?.textAlignment = .Center
        
        if imageArray != nil && imageArray.count == titleArray.count {
            cell?.imageView?.image = UIImage(named: imageArray.object(at: indexPath.row) as! String)
        }
        
        let boView = UIView(frame: CGRect(
            x: 0, y: cell!.contentView.frame.size.height-0.5,
            width: cell!.contentView.frame.size.width, height: 0.5)
        )
        boView.backgroundColor = RGB(174,174,174)
        
        cell?.contentView.addSubview(boView)
        
        if (NSString(string: UIDevice.current.systemVersion).floatValue >= 7.0) {
            cell?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectRowAtIndex(indexPath.row)
        dismiss(true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ROW_HEIGHT
    }
    
    /**
    获取字符串Rect
    
    - parameter    fontSize: 字体大小
    - parameter    width: 显示的宽度
    - returns:  CGRect
    */
    func stringRectWithFontSize(_ str:String, fontSize:CGFloat, width:CGFloat) -> CGRect {
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let  attributes = [
            NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()
        ]
        
        let text = str as NSString
        let rect = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context:nil)
        
        return rect
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        borderColor.set()//设置线条颜色
        let frame = CGRect(x: 0, y: 10, width: self.bounds.size.width, height: self.bounds.size.height - kArrowHeight)
        let xMin = frame.minX
        let yMin = frame.minY
        let xMax = frame.maxX
        let yMax = frame.maxY
        let arrowPoint = self.convert(showPoint, from: handerView)
        let popoverPath = UIBezierPath()
        popoverPath.move(to: CGPoint(x: xMin, y: yMin))
        
        //左上角
        popoverPath.addLine(to: CGPoint(x: arrowPoint.x - kArrowHeight, y: yMin))//left side
        popoverPath.addCurve(
            to: arrowPoint,
            controlPoint1: CGPoint(x: arrowPoint.x - kArrowHeight + kArrowCurvature, y: yMin),
            controlPoint2:
            arrowPoint
        ) //actual arrow point
            
        popoverPath.addCurve(
            to: CGPoint(x: arrowPoint.x + kArrowHeight, y: yMin),
            controlPoint1:arrowPoint,
            controlPoint2:CGPoint(x: arrowPoint.x + kArrowHeight - kArrowCurvature, y: yMin)
        )//right side
        
        popoverPath.addLine(to: CGPoint(x: xMax, y: yMin))//右上角
        popoverPath.addLine(to: CGPoint(x: xMax, y: yMax))//右下角
        popoverPath.addLine(to: CGPoint(x: xMin, y: yMax))//左下角

        //填充颜色
        RGB(245, 245, 245).setFill()
        popoverPath.fill()

        popoverPath.close()
        popoverPath.stroke()
    }

}
