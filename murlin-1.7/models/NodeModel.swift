//
//  NodeModel.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import RealmSwift


final class Node: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Item. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
 
    @Persisted var uuid: UUID = .init()
    @Persisted var created: Date = .init()
    @Persisted var updated: Date = .init()
    
    // CONTENT
    @Persisted var title: String = ""
        { didSet { updated = .init() } }
    @Persisted var note: String = ""
        { didSet { updated = .init() } }
    @Persisted var _url: String? = nil
        { didSet { updated = .init() } }

    // EDGES
    @Persisted var outgoing = RealmSwift.List<Node>()
        { didSet { updated = .init() } }
    @Persisted(originProperty: "outgoing") var incoming: LinkingObjects<Node>
    // TAGS
    @Persisted(originProperty: "nodes")  var tags: LinkingObjects<Tag>

    // PINNED
    @Persisted var pinned: Bool = false


    var url: URL? {
        get {
            return URL(string: _url ?? "")
        } set {
            _url = newValue?.absoluteString ?? nil
        }
    }
}
