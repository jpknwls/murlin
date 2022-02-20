//
//  DatabaseTypes.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import RealmSwift
enum RealmError: LocalizedError {
  case failToOpenRealm
  case failToTypeCasting
}

struct NodeProjection: Equatable {
    let id: ObjectId
    let uuid: UUID
    let title: String
    let note: String
}
