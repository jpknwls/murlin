//
//  database.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation

import Foundation
import RealmSwift
import os

extension Realm {
    static var schemaVersion: UInt64 = 2
}

extension Realm {
    static var DB: Realm? {
        let configuration = Realm.Configuration(schemaVersion: Realm.schemaVersion)
        do {
            let realm = try Realm(configuration: configuration)
            return realm
        } catch {
            os_log(.error, "Error opening realm: \(error.localizedDescription)")
            return nil
        }
    }

    static var config: Realm.Configuration {
        Realm.Configuration(schemaVersion: Realm.schemaVersion)
    }
}



/*

    operations
 */
 
 

 /*
    SEME
  */
 // CREATE

func addNode(from text: String) -> Node? {
    if let db = Realm.DB {
        let node = Node()
        try! db.write {
            node.title = text
            db.add(node)
        }
        return node
    }
    return nil
}








func loadRandomData() -> Node {

    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789                          "
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
 
    let realm = try! Realm()
            
    try! realm.write {
        for _ in 1..<100 {
            let titleLength =  Int.random(in: 1..<40)
            let noteLength =  Int.random(in: 1..<100)
            let childrenNumber = Int.random(in: 1..<5)
            var children: Set<ObjectId> = []

            let block = Node()
            block.title = randomString(length: titleLength)
            block.note = randomString(length: noteLength)
            for _ in 0..<childrenNumber {
                if let random = realm.objects(Node.self).randomElement() {
                    children.insert(random._id)
                }
            }
            for child in children {
                if let c = realm.object(ofType: Node.self, forPrimaryKey: child) {
                    block.outgoing.append(c)
                }
                
            }
            realm.add(block)
  
        }
    
        

    }
    
    return realm.objects(Node.self).randomElement()!
}


