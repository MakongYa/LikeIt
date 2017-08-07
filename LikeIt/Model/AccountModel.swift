

import UIKit

class AccountModel: JKDBModel {
    
    var accountId: NSNumber!
    var title: String!
    var money: NSNumber!
    
    override init() {
        
    }
    
    init(title:String, money:NSNumber) {
        self.title = title
        self.money = money
    }
    
}
