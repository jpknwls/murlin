//
//  database.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import Combine
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

extension Realm.Configuration {
    var defaultConfiguration: Realm.Configuration {
        Realm.config
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


//func queryDatabase(text: String? = nil, filters: Set<Tag>? = nil, sort: SortOrder) -> Promise<Results<Node>> {
//     if let db = Realm.DB {
//        var objects = db.objects(Node.self)
//
//        guard let text = text, !text.isEmpty else {
//            switch sort {
//                case .updatedAge(let ascending):
//                    objects = objects.sorted(by: \.updated, ascending: ascending)
//                case .createdAge(let ascending):
//                    objects = objects.sorted(by: \.created, ascending: ascending)
//                case .alphabetical(let ascending):
//                    objects = objects.sorted(by: \.title, ascending: ascending)
//            }
//        
//         return objects
//        
//        }
//        objects = objects.filter("title beginswith %@", text)
//        switch sort {
//                case .updatedAge(let ascending):
//                    objects = objects.sorted(by: \.updated, ascending: ascending)
//                case .createdAge(let ascending):
//                    objects = objects.sorted(by: \.created, ascending: ascending)
//                case .alphabetical(let ascending):
//                    objects = objects.sorted(by: \.title, ascending: ascending)
//            }
//        return objects
//    
//    }
//    return nil
//}





func loadRandomData()  {

    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789                          "
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
 
    guard let realm = Realm.DB else {return }
            
    try! realm.write {
    
       
        for _ in 1..<10000 {
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
    
         for _ in 1..<10 {
            let tag = Tag()
            tag.name = randomString(length: Int.random(in: 4...20))
            var nodesToAdd: Set<Node> = []
            for _ in 1..<Int.random(in: 4...20) {
                if let node = realm.objects(Node.self).randomElement() {
                    nodesToAdd.insert(node)
                }
            }
            realm.add(tag)
        }
        

    }
    
 //   return realm.objects(Node.self).randomElement()!
}




   
//
//  RealmRepository.swift
//  Cob
//
//https://github.com/COBulletins/COB-iOS/blob/main/Cob/Repositories/RealmRepository.swift
//
//  Created by DaEun Kim on 2022/01/08.
//
import Combine
import Foundation

import RealmSwift


struct Repository: RealmRepository {

  let configuration: Realm.Configuration
  let bgQueue = DispatchQueue(label: "bg_murlin_realm_queue")
  
  init(configuration: Realm.Configuration = Realm.config) {
    self.configuration = configuration
  }
}

protocol RealmRepository {
  var configuration: Realm.Configuration { get }
  var bgQueue: DispatchQueue { get }
  
}

// MARK: - Realm
extension RealmRepository {
  var realm: Realm? {
    try? Realm(configuration: configuration, queue: bgQueue)
  }
}

// MARK: - Realm CRUD
extension RealmRepository {
    
  func fetchNodes(for text: String = "", filters: Set<Tag>? = nil, sort: SortOrder = .updatedAge(false)) -> AnyPublisher<([NodeProjection], String), Error> {
    future { (promise) in
      bgQueue.async {
        autoreleasepool {
          guard let realm = Realm.DB else {  return promise(.failure(RealmError.failToOpenRealm)) }
            
            
          var results = realm.objects(Node.self)
          if let filters = filters, !filters.isEmpty {
                 results = results.where {
                    $0.tags.containsAny(in: filters)
                 }
          }
          
          if !text.isEmpty {
                let titlePred = NSPredicate(format: "title beginswith %@", text)
                let notePred = NSPredicate(format: "note beginswith %@", text)
                let compPred = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePred, notePred])
                 results = results.filter(compPred)
          }
          
            switch sort {
                case .updatedAge(let ascending):
                    results = results.sorted(by: \.updated, ascending: ascending)
                case .createdAge(let ascending):
                    results = results.sorted(by: \.created, ascending: ascending)
                case .alphabetical(let ascending):
                    results = results.sorted(by: \.title, ascending: ascending)
            }
         
             var projections: [NodeProjection] = []
            for result in results {
                projections.append(NodeProjection(id: result._id, uuid: result.uuid, title: result.title, note: result.note))
            }
          promise(.success((projections, text)))
        }
      }
    }
    .eraseToAnyPublisher()
  }

//  func fetchObject<T: Object>(for primaryKey: String) -> AnyPublisher<T, Error> {
//    future { (promise) in
//      bgQueue.async {
//        autoreleasepool {
//          guard let realm = realm else { return promise(.failure(RealmError.failToOpenRealm)) }
//
//          guard let object = realm.object(ofType: T.self, forPrimaryKey: primaryKey) else {
//            return promise(.failure(RealmError.failToTypeCasting))
//          }
//          promise(.success(object))
//        }
//      }
//    }
//    .eraseToAnyPublisher()
//  }
//
//  @discardableResult
//  func add<T: Object>(object: T) -> AnyPublisher<T, Error> {
//    future { (promise) in
//      bgQueue.async {
//        autoreleasepool {
//          guard let realm = realm else { return promise(.failure(RealmError.failToOpenRealm)) }
//
//          do {
//            let object: T = try realm.safeWrite {
//              realm.add(object, update: .all)
//              return object
//            }
//            promise(.success(object))
//          } catch let error {
//            promise(.failure(error))
//          }
//        }
//      }
//    }
//    .eraseToAnyPublisher()
//  }
//
//  @discardableResult
//  func update<T: Object>(object: T) -> AnyPublisher<T, Error> {
//    future { (promise) in
//      bgQueue.async {
//        autoreleasepool {
//          guard let realm = realm else { return promise(.failure(RealmError.failToOpenRealm)) }
//
//          do {
//            let object: T = try realm.safeWrite {
//              realm.add(object, update: .modified)
//              return object
//            }
//            promise(.success(object))
//          } catch let error {
//            promise(.failure(error))
//          }
//        }
//      }
//    }
//    .eraseToAnyPublisher()
//  }
//
//  func remove<T: Object>(object: T) -> AnyPublisher<Void, Error> {
//    future { (promise) in
//      bgQueue.async {
//        autoreleasepool {
//          guard let realm = realm else { return promise(.failure(RealmError.failToOpenRealm)) }
//
//          do {
//            try realm.safeWrite {
//              realm.delete(object)
//            }
//            promise(.success(()))
//          } catch let error {
//            promise(.failure(error))
//          }
//        }
//      }
//    }
//    .eraseToAnyPublisher()
//  }
//
//  func removeAll() -> AnyPublisher<Void, Error> {
//    future { (promise) in
//      bgQueue.async {
//        autoreleasepool {
//          guard let realm = realm else { return promise(.failure(RealmError.failToOpenRealm)) }
//
//          do {
//            try realm.safeWrite {
//              realm.deleteAll()
//            }
//            promise(.success(()))
//          } catch let error {
//            promise(.failure(error))
//          }
//        }
//      }
//    }
//    .eraseToAnyPublisher()
//  }
}

// MARK: - Private function
/// A deferred future backed by a passthrough subject.
/// Note: This is because Future can create a memory leak.
private func future<Output, Failure: Error>(
  _ attemptToFulfill: @escaping (@escaping (Result<Output, Failure>) -> Void) -> Void
) -> AnyPublisher<Output, Failure> {
  Deferred<PassthroughSubject<Output, Failure>> {
    let subject = PassthroughSubject<Output, Failure>()
    attemptToFulfill { result in
      switch result {
      case .success(let value):
        subject.send(value)
        subject.send(completion: .finished)
      case .failure(let error):
        subject.send(completion: .failure(error))
      }
    }
    return subject
  }
  .eraseToAnyPublisher()
}
