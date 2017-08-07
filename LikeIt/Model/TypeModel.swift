

import UIKit

class TypeModel: JKDBModel {
   
    var typeId: NSNumber!      // ID  spend || income
    var typeTitle: String!     // 类型
    var typePicName: String!   // 类型图标
    var typeIsSys: NSNumber!   // 是默认图标 0:true， 1:false

    override init() {
        
    }
    
    init(typeId: NSNumber, typeTitle: String, typePicName: String, typeIsSys: NSNumber) {
        self.typeId = typeId
        self.typeTitle = typeTitle
        self.typePicName = typePicName
        self.typeIsSys = typeIsSys
    }
   
}
