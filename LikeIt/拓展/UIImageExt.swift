

import UIKit

extension UIImage {

    var color: UIColor {
        let width = self.size.width
        let height = self.size.height
        let pointX = trunc(width/2)
        let pointY = trunc(CGFloat(5))
        let cgImage = self.cgImage
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * 1
        let bitsPerComponent = 8
        var pixelData = [0,0,0,0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        
        context?.setBlendMode(CGBlendMode.copy)
        context?.translateBy(x: -pointX, y: pointY-height)
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
    
        print(pixelData[0],pixelData[1],pixelData[2],pixelData[3])
        
        let r = CGFloat(pixelData[0])/255.0
        let g = CGFloat(pixelData[1])/255.0
        let b = CGFloat(pixelData[2])/255.0
      
        print(r)
        print(g)
        print(b)
        
        return UIColor(r: r, g: g, b: b)
    }
    
    
    /// 获取图片中的像素颜色值
    ///
    /// - parameter pos: 图片中的位置
    /// - returns: 颜色值
    func getPixelColor(_ pos:CGPoint)->(alpha: CGFloat, red: CGFloat, green: CGFloat,blue:CGFloat){
        let pixelData=self.cgImage?.dataProvider?.data
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return (a,r,g,b)
    }
}


extension UIButton {
    
    func setImage(_ img: UIImage?) {
        guard img != nil else {
            return
        }
        self.setImage(img, for: UIControlState())
    }
    
    func setBackgroundImage(_ img: UIImage?) {
        guard img != nil else {
            return
        }
        self.setBackgroundImage(img, for: UIControlState())
    }
}




