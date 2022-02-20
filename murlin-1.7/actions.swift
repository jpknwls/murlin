//
//  actions.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import CoreGraphics
import SwiftUI
import RealmSwift

enum AppAction {
    /* DEVICE */
    case startOrientationListening
    case startKeyboardHideListening
    case startKeyboardChangeListening
    case updateOrientation(Orientation)
    case hideKeyboard
    case setKeyboardHeight(CGRect)
    /* NAVIGATION */
    case push(AnyView, String? = nil)
    case pop(PopDestination = .previous)
    
    /* NODES STATE */
    /* NODE STATE */
    case updateSearchText(String)
    case updateMode(Mode)
    case loadQuery
    case updateQuery([NodeProjection], String)
    case updateSortOrder(SortOrder)

    case empty
}

/*

enum DeviceAction {
    case startOrientationListening
    case startKeyboardHideListening
    case startKeyboardChangeListening
    
    case updateOrientation(Orientation)
    
    case hideKeyboard
    case setKeyboardHeight(CGRect)
    
    case null

}

enum NodeAction {
    case toggleTagsShowing(Bool)
    case toggleNodesShowing(Bool)
    case toggleBacklinksShowing(Bool)

}

enum RootAction {
    case updateFilters(Set<Tag>)
    // bindings
    case updateSearchText(String)
    case updateSortOrder(SortOrder)
    case updateNodeSelection(Set<Node>)
    case updateMode(RootMode)
    case toggleEditingFilter(Bool)
    case toggleAddingTags(Bool)
    case toggleAddingNodes(Bool)
    case toggleSettingsShowing(Bool)
    case addNode
    case transitionToNode(Node)
    case toggleSort
}


navigation
    push
    pop

 */
