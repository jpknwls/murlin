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
    var searching = Dictionary<UUID, NodeSearchState>()
    let rootID: UUID = .init()
    
    var nodes: [NodeProjection] = []
    
    init() {
        searching[rootID] = NodeSearchState()
        //nodes = queryDatabase(sort: .updatedAge(false))
    }

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
                    case .nodes(let mode):
                        if let state = update.searching[update.rootID] {
                            var copy = state
                            copy.searchText = newText
                            update.searching[update.rootID] = copy
                            return Update(state: update, fx:
                                    environment.repository
                                        .fetchNodes(for: copy.searchText)
                                        .receive(on: RunLoop.main)
                                        .map { results, string in
                                            return AppAction.updateQuery(results, string) }
                                        .catch { _ in Just(.empty) }
                                        .eraseToAnyPublisher())
                            
                        }
                        
                    case .node(let mode, let node):
                        if let state = update.searching[node.uuid] {
                            var copy = state
                            copy.searchText = newText
                            update.searching[node.uuid] = copy
                            break
                        }
                }
                return Update(state: update)

            
            case .updateMode(let newMode):
                var update = model
                update.state.mode = newMode
                return Update(state: update)
                
            case .updateQuery(let results, let string):
                var update = model
                guard let text = update.searching[update.rootID]?.searchText, text == string
                else { return Update(state: update) }
                // dont update if our query is for a different string
                update.nodes = results
                print("updating results")
                return Update(state: update)
                
            case .updateSortOrder(let order):
                var update = model
                switch update.state.mode {
                    case .nodes(let mode):
                        if var searchState = update.searching[update.rootID] {
                             searchState.sort = order
                             update.searching[update.rootID] = searchState
                        }
                    case .node(let mode, let node):
                        if var searchState = update.searching[node.uuid] {
                             searchState.sort = order
                             update.searching[node.uuid] = searchState
                        }
                }
                return Update(state: update)
            default:
                    return nil
        }
    }
}

    
