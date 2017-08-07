

import UIKit

class AddModel: JKDBModel {
    
    var addType: NSNumber!     // spend?income
    var addMoney: NSNumber!    // 金额
    var time: NSNumber!        // 什么时候花的
    var typePK: String!     // 类型
    var addContent: String!    // 备注
    var accountId: NSNumber!   // 账户
    var addTime: NSNumber!     // 纪录添加的时间
    
    override init() {
        
    }
    
    init(type:NSNumber, money:NSNumber, time: NSNumber, typePK:String, addTime:NSNumber, content:String, accountId:NSNumber) {
        self.addType = type
        self.addMoney = money
        self.time = time
        self.typePK = typePK
        self.addTime = addTime
        self.addContent = content
        self.accountId = accountId
    }
    
}
