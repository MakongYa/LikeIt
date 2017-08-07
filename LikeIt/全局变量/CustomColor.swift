

import UIKit

class CustomColor {
    
    /// 主题色(橙)
    static let themeColor = RGB(246,113,52)
    
    /// 浅(橙)
    static let shadowOrangeColor = RGB(237,205,130)
    
    /// 支出类型颜色
    static let spendColor = RGB(226,59,67)
    
    /// 收入类型颜色
    static let inComeColor = RGB(27,161,100)
    
    /// view244
    static let viewBackgroundColor = RGB(244,244,244)
    
    /// 线条颜色149
    static let lineColor = RGB(149,149,149)
    
    /// 阴影颜色232
    static let shadowColor = RGB(232,232,232)
    
    /// 灰色158
    static let garyFontColor = RGB(158,158,158)
    
    /// 灰色214
    static let garyFont2Color = RGB(214,214,214)
    
    /// 灰色226
    static let garyFont3Color = RGB(226,226,226)
    
    /// 灰色108
    static let garyFont4Color = RGB(108,115,122)
    
    /// 暗黑119
    static let diabloBlackFontColor = RGB(119,119,119)
    
    /// 绿色
    static let green = RGB(77, 186, 255)
    
    /// 深绿色
    static let lightGreen = RGB(77,216,255)
}


let PNGrey = RGB(246,246,246)
let PNLightBlue = RGB(94,147,196)
let PNGreen = RGB(77,186,122)
let PNLightGreen = RGB(77,216,122)
let PNFreshGreen = RGB(77,196,122)
let PNDeepGreen = RGB(77,176,122)
let PNRed = RGB(245,94,78)
let PNMauve = RGB(88,75,103)
let PNBrown = RGB(119,107,95)
let PNBlue = RGB(82,116,188)
let PNDarkBlue = RGB(121,134,142)
let PNYellow = RGB(242,197,117)
let PNDeepGrey = RGB(255,99,99)
let PNPinkGrey = RGB(200,193,193)
let PNHealYellow = RGB(245,242,238)
let PNLightGrey = RGB(225,225,225)
let PNCleanGrey = RGB(251,251,251)
let PNLightYellow = RGB(241,240,240)
let PNDarkYellow = RGB(152,150,159)
let PNPinkDark = RGB(170,165,165)
let PNCloudWhite = RGB(244,244,244)
let PNBlack = RGB(45,45,45)
let PNStarYellow = RGB(252,233,101)
let PNTwitterColor = RGB(0,170,243)
let PNWeiboColor = RGB(250,0,33)
let PNiOSGreenColor = RGB(98,247,77)

let colorArr:[UIColor] = [PNLightBlue,PNGreen,PNLightGreen,PNFreshGreen,PNDeepGreen,PNRed,PNMauve,PNBrown,
PNBlue,PNDarkBlue,PNYellow,PNDeepGrey,PNPinkGrey,PNHealYellow,PNLightGrey,PNCleanGrey,PNLightYellow,PNDarkYellow,PNPinkDark,PNCloudWhite,PNBlack,PNStarYellow,PNStarYellow,PNTwitterColor,PNWeiboColor,
    PNiOSGreenColor
]


let colorWithTypePic = [
    "爱好"    :"#FF9AB6","背包"    :"#F18F53","标签"   :"#968B9C","冰淇淋"    :"#9E7866","餐饮"   :"#81ACA9",
    "吃饭"    :"#B4BA3D","宠物"    :"#C2891B","存钱"   :"#B5BA3E","地铁"      :"#6B83B7","电视"   :"#EAAD13",
    "电影"    :"#9E7866","房子"    :"#D1B95D","房租"   :"#5DC377","飞机"      :"#7F8B36","更多"   :"#8884E5",
    "工资"    :"#6B83B7","公文包"  :"#5FB0C5","购物"    :"#EB8ABE","购物车"    :"#D05C4C","还钱"   :"#8EBCDF",
    "红包"    :"#E05B26","化妆品"  :"#E2728D","记事本"  :"#A06E40","健身"      :"#3A6B3A","奖金"   :"#ED9241",
    "教育"    :"#6FAA70","借钱"    :"#8EBCDF","酒水"   :"#","篮球"      :"#","礼物"   :"#",
    "沙发"    :"#E36C1C","生活用品" :"#39C4DA","生鲜"   :"#","食用油"    :"#","收入"   :"#",
    "手机通讯" :"#F0D5A9","书"      :"#","水电"   :"#","水果"      :"#","投资"   :"#",
    "维修"    :"#6D7C81","香烟"     :"#","鞋子"   :"#","星星"     :"#","摇椅"   :"#",
    "衣架"    :"#B47CA7","医院"     :"#","银行卡"  :"#","饮料"     :"#","婴儿"   :"#",
    "照相"    :"#B5A353","支出"     :"#","纸巾"    :"#","KTV"     :"#","Tag"   :"#"
    ]



func RGB(_ cf: CGFloat...) -> UIColor {
    if cf.count > 3 {
        return UIColor()
    }
    return UIColor(red: cf[0]/255, green: cf[1]/255, blue: cf[2]/255, alpha: 1)
}









