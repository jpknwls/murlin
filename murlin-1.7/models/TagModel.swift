//
//  TagModel.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import RealmSwift



final class Tag: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Item. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
 
    @Persisted var uuid: UUID = .init()
    @Persisted var name: String = ""
    @Persisted var nodes = RealmSwift.List<Node>()

}
