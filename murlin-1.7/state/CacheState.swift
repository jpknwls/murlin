//
//  CacheState.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import LinkPresentation
import Combine

/*
    manages an interface with caching system
        returns LPLinkMetadata for URL strings


        linkCache
        
*/

struct CacheState: Equatable {
    var linkCache: [String: LPLinkMetadata] = [:] {
        didSet {
            saveCacheState()
        }
    }
    
}


extension CacheState {

    
    mutating func setLinkMetadata(key: String, metadata: LPLinkMetadata) {
         self.linkCache[key] = metadata
    }
    
    func addLinkToCache(url: URL) -> Fx<AppAction> {
        if let _ = linkCache[url.absoluteString] { return Empty().eraseToAnyPublisher() }
        return fetchMetadata(url: url).eraseToAnyPublisher()
    }
      
    
    
    func fetchMetadata(url: URL) -> Future <AppAction, Never> {
        return Future() { promise in
            DispatchQueue.main.async {
                let metadataProvider = LPMetadataProvider()
                metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
                    if let metadata = metadata {
                       promise(Result.success(.setLinkMetadata(url.absoluteString, metadata)))
                    }
                    else if let error = error {
                        // .. we can never fail...
                       // promise(Result.s)
                       print(error)
                       promise(Result.success(.empty))
                    }
                }

            }
        }
    }
    mutating func loadLinksCache() {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let linksURL = docDirURL.appendingPathComponent("links")
        if FileManager.default.fileExists(atPath: linksURL.path) {
            do {
                let data = try Data(contentsOf: linksURL)

                guard let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String:LPLinkMetadata] else { return }
                linkCache = unarchived
            } catch {
                print(error.localizedDescription)
            }
        }
        

    }

    func saveCacheState() {
                guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let linksURL = docDirURL.appendingPathComponent("links")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: linkCache, requiringSecureCoding: false)
            try data.write(to: linksURL)
        } catch {
            print("ERROR SAVING CACHE")
        }
    }
}
    





    
//    }
//
//
//    func add(key: String ) {
//        if let _ = linkCache[key] { return }
//        guard let url = URL(string: key) else { return }
//
//        let cancellable = fetchMetadata(url: url)
//            .sink(
//                    receiveCompletion: {error in },
//                    receiveValue: {metadata in
//                        let link = MurLink(metadata: metadata)
//                        self.linkCache[key] = link
//                })
//
//    }
//
//
//     func fetchMetadata(url: URL) -> Future <LPLinkMetadata, Error> {
//        return Future() { promise in
//            DispatchQueue.main.async {
//                let metadataProvider = LPMetadataProvider()
//                metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
//                    if let metadata = metadata {
//                       promise(Result.success(metadata))
//                    }
//                    else if let error = error {
//                        // .. we can never fail...
//                        promise(Result.failure(error))
//                    }
//                }
//
//            }
//        }
//    }
