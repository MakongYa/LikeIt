

import Foundation
import UIKit



/// 屏幕的宽
let screenWidth = UIScreen.main.bounds.width
/// 屏幕的高
let screenHeight = UIScreen.main.bounds.height

let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
let IS_IPHONE_6P = IS_IPHONE && screenHeight == 736
let IS_IPHONE_6 = IS_IPHONE && screenHeight == 667
let IS_IPHONE_5 = IS_IPHONE && screenHeight == 568
let IS_IPHONE_4_4s = IS_IPHONE && screenHeight == 480


//自动适配缩放比例
var autoSizeScaleX:CGFloat! = 1.0
var autoSizeScaleY:CGFloat! = 1.0

func CGRectAutoMake(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect{
    var rect = CGRect()
    rect.origin.x = x * autoSizeScaleX
    rect.origin.y = y * autoSizeScaleY
    rect.size.width = width * autoSizeScaleX
    rect.size.height = height * autoSizeScaleY
    
    return rect
}

func storyBoradAutoLay(_ allView:UIView){
    
     for view:UIView in allView.subviews {
    
        view.frame = CGRectAutoMake(view.frame.origin.x,
        y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
  
        for temp1:UIView in view.subviews {
            temp1.frame = CGRectAutoMake(
                temp1.frame.origin.x,
                y: temp1.frame.origin.y,
                width: temp1.frame.size.width,
                height: temp1.frame.size.height
            )
        }
    }
}

class UIMaker: NSObject {
    
    private static let maker = UIMaker()
    
    class func shareInstance()->UIMaker{
        return maker
    }
    
    override init() {
        if(screenHeight > 480){
            autoSizeScaleX = screenWidth/320;
            autoSizeScaleY = screenHeight/568;
        }else{
            autoSizeScaleX = 1.0
            autoSizeScaleY = 1.0
        }
    }
    
}


func getWindow() ->UIWindow {
    if let delegate: UIApplicationDelegate = UIApplication.shared.delegate {
        if let window = delegate.window {
            return window!
        }
    }
    
    return UIApplication.shared.keyWindow!
}

func storyBoradAutoLay2(_ allView:UIButton){
    
    allView.frame = CGRectAutoMake(allView.frame.origin.x,
    y: allView.frame.origin.y, width: allView.frame.size.width, height: allView.frame.size.height)
    
}
