

import UIKit

class SubTypeModel: JKDBModel {
    
    var typeId: NSNumber!       // 类型ID
    var subTypeId: NSNumber!    // 子类型ID
    var subTypeTitle: String!   // 子类型
    
    
    init(subTypeId:NSNumber, tagTitle:String) {
        self.subTypeId = subTypeId
        self.subTypeTitle = tagTitle
    }

}
