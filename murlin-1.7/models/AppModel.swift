//
//  AppModel.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import Combine
import UIKit
import SwiftUI
import RealmSwift

struct AppModel: Equatable {
    var mode = ModeTree()
    var device = DeviceState()
    var navigation = NavigationState()
    var cache = CacheState()
    var focusedNode: Node?


    
    
    var nodeState = Dictionary<UUID, NodeSearchState>()
    var nodesState = NodesSearchState()
    var nodes: [NodeProjection] = []


    /*
        KEY: PUT WITH ANIMATION HERE!!!!!!
        
     */
    static func update(
        model: AppModel,
        environment: AppEnvironment,
        action: AppAction
    ) -> Update<AppModel, AppAction>? {
        switch action {
        
/*
         ------------------------- DEVICE ----------------------
       
 */
            case .startOrientationListening:
                return Update(
                    state: model,
                    fx: environment.startOrientationListening())
         
            case .updateOrientation(let newOrientation):
                var update = model
                update.device.orientation = newOrientation
                return Update(state: update)
            
            case .startKeyboardListening:
                return Update(
                        state: model,
                        fx: environment.startKeyboardListening())

            case .updateKeyboard(let newRect):
                var update = model
                withAnimation(.easeInOut) {
                    if newRect.origin.y >= UIScreen.main.bounds.height {
                        update.device.keyboard = .zero
                    } else {
                        update.device.keyboard = newRect
                    }
                }
                return Update(state: update)

/*
        ------------------------- NAVIGATION ----------------------
*/
           case .go(let destination):
             var update = model
             withAnimation(update.navigation.easing) {
                update.navigation.navigationType = .pop
                switch destination {
                    case .root:
                       // update.navigation.viewStack.popToRoot()
                        break
                    case .view(let viewId):
                        if let goTo = update.navigation.viewMap[viewId] {
                            update.navigation.currentView = goTo
                        }
                    default: break
                      //  update.navigation.viewStack.popToPrevious()
                    }
        
            }
            return Update(state: update)

           case .add(let node):
            var update = model
             withAnimation(update.navigation.easing) {
                update.navigation.navigationType = .push
//                update.navigation.viewStack.push(
//                    ViewElement(
//                        id: id,
//                        wrappedElement: newView))
//
                let newView = AnyView(NodeView(node: node))
                let newElement = ViewElement(
                        node: node,
                        wrappedElement: newView)
                
                update.navigation.viewMap[node.uuid.uuidString] = newElement
                update.navigation.currentView = newElement
            }
            return Update(state: update)
            
            case .remove(let id):
                var update = model
                update.navigation.viewMap.removeValue(forKey: id)
                return Update(state: update)
/*
        ------------------------- MODE ----------------------
*/


            case .updateTab(let newMode):
                var update = model
                update.mode.tab = newMode
                switch newMode {
                    case .node(let mode, let node):
                        update.navigation.update(to: node.uuid.uuidString)
                    default: break
                }
                return Update(state: update)
                
            case .updateSheet(let newSheet):
                var update = model
                update.mode.sheet = newSheet
                return Update(state: update)


/*
        ------------------------- CACHE ----------------------
*/


        case .addLinkMetadataKey(let url):
            return Update(state: model, fx: model.cache.addLinkToCache(url: url))
            

        case .setLinkMetadata(let key, let metadata):
            var update  = model
            update.cache.setLinkMetadata(key: key, metadata: metadata)
            return Update(state: model)

/*
        ------------------------- FOCUS ----------------------
*/

        case .updateFocus(let newFocus):
            var update = model
            update.focusedNode = newFocus
            return Update(state: model)








/*
        ------------------------- STATE ----------------------
*/
            case .loadQuery:
                return Update(state: model, fx:
                                    environment.repository
                                        .fetchNodes()
                                        .receive(on: RunLoop.main)
                                        .map { results, string in
                                            return AppAction.updateQuery(results, string) }
                                        .catch { _ in Just(.empty) }
                                        .eraseToAnyPublisher())
    
            case .updateSearchText(let newText):
                var update = model
                switch update.mode.tab {
                    case .search(let mode):
                            update.nodesState.searchText = newText
                            return Update(state: update, fx:
                                    environment.repository
                                        .fetchNodes(for: update.nodesState.searchText, filters: update.nodesState.filters, sort: update.nodesState.sort )
                                        .receive(on: RunLoop.main)
                                        .map { results, string in
                                            return AppAction.updateQuery(results, string) }
                                        .catch { _ in Just(.empty) }
                                        .eraseToAnyPublisher())
                            
                        
                        
                    case .node(let mode, let node):
                        if let state = update.nodeState[node.uuid] {
                            var copy = state
                            copy.searchText = newText
                            update.nodeState[node.uuid] = copy
                            break
                        }
                    case .home(let mode):
                        // TODO:
                        break
                }
                return Update(state: update)

            
            case .updateQuery(let results, let string):
                var update = model
                guard update.nodesState.searchText == string
                else { return Update(state: update) }
                // dont update if our query is for a different string
                withAnimation(.easeIn) {
                    update.nodes = results
                }
                return Update(state: update)
                
            case .updateSortOrder(let order):
                var update = model
                switch update.mode.tab {
                    case .search(let mode):
                        // TODO:
                        break
                    case .home(let mode):
                         update.nodesState.sort = order
                         return Update(state: update, fx:
                                environment.repository
                                    .fetchNodes(for: update.nodesState.searchText, filters: update.nodesState.filters, sort: update.nodesState.sort)
                                    .receive(on: RunLoop.main)
                                    .map { results, string in
                                        return AppAction.updateQuery(results, string) }
                                    .catch { _ in Just(.empty) }
                                    .eraseToAnyPublisher())
                         
                        
                    case .node(let mode, let node):
                        if var searchState = update.nodeState[node.uuid] {
                             searchState.sort = order
                             update.nodeState[node.uuid] = searchState
                        }
                }
                return Update(state: update)
            
            case .updateFilters(let newFilters):
                var update = model
                switch update.mode.tab {
                    case .search(let mode):
                        break
                        // TODO: 
                    case .home(let mode):
                        update.nodesState.filters = newFilters
                        return Update(state: update, fx:
                                    environment.repository
                                        .fetchNodes(for: update.nodesState.searchText, filters: update.nodesState.filters, sort: update.nodesState.sort)
                                        .receive(on: RunLoop.main)
                                        .map { results, string in
                                            return AppAction.updateQuery(results, string) }
                                        .catch { _ in Just(.empty) }
                                        .eraseToAnyPublisher())
                             
                        
                    case .node(let mode, let node):
                        if var searchState = update.nodeState[node.uuid] {
                             searchState.filters = newFilters
                             update.nodeState[node.uuid] = searchState
                        }
                }
                return Update(state: update)
            default:
                    return nil
        }
    }
}

    
