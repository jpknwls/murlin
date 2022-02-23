//
//  BlockModel.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/20/22.
//

import Foundation
import RealmSwift
import UIKit

protocol _Int {}
extension Int: _Int {}

extension Range where Bound: _Int  {
    var string: String {
        let lowerBound = self.lowerBound as! Int
        let upperBound = self.upperBound as! Int
        return lowerBound.description + "," + upperBound.description
    }
}

extension String {
    var toRange: Range<Int>? {
        let parts = self.split(separator: ",")
        guard parts.count == 2 else {
            return nil
        }
        guard let lowerBound = Int(parts[0]),  let upperBound = Int(parts[1]) else {
            return nil
        }
        return Range(lowerBound...upperBound)
    }
}


//final class Block: Object, ObjectKeyIdentifiable {
//    /// The unique ID of the Item. `primaryKey: true` declares the
//    /// _id member as the primary key to the realm.
//    @Persisted(primaryKey: true) var _id: ObjectId
// 
//    @Persisted var uuid: UUID = .init()
//    @Persisted var text: String = ""
//    @Persisted var subBlocks = RealmSwift.List<Block>()
//    @Persisted var markup: RealmSwift.Map<String,Style>? = nil
//    
//    /*
//        https://augmentedcode.io/2021/06/21/exploring-attributedstring-and-custom-attributes/
//     */
//    var attributed: AttributedString {
//        var base = AttributedString(text)
//        var attributeBase = AttributeContainer()
//        for key in markup.keys {
//            if let range = key.toRange {
//                if let style = markup[key] {
//                    switch style.type {
//                        case .shadow: break
//                        case .link: break
//                        case .textEffect: break
//                        case .paragraphStyle: break
//                        case .foregroundColor: break
//                        case .textSize: break
//                        case .backgroundColor: break
//                        
//                    }
//                    //attributeBase[range]
///*
//                    base[range].backgroundColor
//                    base[range].textEffect
//                    base[range].foregroundColor
//                    base[range].font
//                    base[range].paragraphStyle
//                    base[range].link
//                    base[range].shadow
//
// */
//                }
//            }
//        }
//        return base
//    }
//}

/*
    put all default styles in here as optionals
    ....?
 */


enum StyleType: Int, PersistableEnum {
    case textSize
    // case font
    case backgroundColor
    case foregroundColor
    case paragraphStyle
    case textEffect
    case link
    case shadow
}

final class Style: EmbeddedObject {
 //   @Persisted var text:
    @Persisted var type: StyleType

    @Persisted var textSize: Double? = 16.0
    
}
