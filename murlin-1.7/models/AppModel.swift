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
    var state = StateTree()
    var device = DeviceState()
    var navigation = NavigationState()
    var nodeState = Dictionary<UUID, NodeSearchState>()
    var nodesState = NodesSearchState()
    var nodes: [NodeProjection] = []
    

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
            
            case .startKeyboardChangeListening:
                return Update(
                        state: model,
                        fx: environment.startKeyboardChangeListening())
                        
            case .startKeyboardHideListening:
                return Update(
                        state: model,
                        fx: environment.startKeyboardListening())
 
            case .hideKeyboard:
                var update = model
                update.device.keyboard = .zero
                return Update(state: update)

            case .setKeyboardHeight(let newRect):
                var update = model
                if newRect.origin.y >= UIScreen.main.bounds.height {
                    update.device.keyboard = .zero
                } else {
                    update.device.keyboard = newRect
                }
                return Update(state: update)

/*
        ------------------------- NAVIGATION ----------------------
*/
           case .pop(let destination):
             var update = model
             withAnimation(update.navigation.easing) {
                update.navigation.navigationType = .pop
                switch destination {
                    case .root:
                        update.navigation.viewStack.popToRoot()
                    case .view(let viewId):
                        update.navigation.viewStack.popToView(withId: viewId)
                    default:
                        update.navigation.viewStack.popToPrevious()
                    }
        
            }
            return Update(state: update)

           case .push(let newView, let id):
            var update = model
             withAnimation(update.navigation.easing) {
                update.navigation.navigationType = .push
                update.navigation.viewStack.push(
                    ViewElement(
                        id: id == nil ? UUID().uuidString : id!,
                        wrappedElement: newView))
            }
            return Update(state: update)
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
                switch update.state.mode {
                    case .home(let mode):
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
                    case .search(let mode):
                        // TODO:
                        break
                }
                return Update(state: update)

            
            case .updateMode(let newMode):
                var update = model
                update.state.mode = newMode
                return Update(state: update)
                
            case .updateQuery(let results, let string):
                var update = model
                guard update.nodesState.searchText == string
                else { return Update(state: update) }
                // dont update if our query is for a different string
                update.nodes = results
                return Update(state: update)
                
            case .updateSortOrder(let order):
                var update = model
                switch update.state.mode {
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
                switch update.state.mode {
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

    
