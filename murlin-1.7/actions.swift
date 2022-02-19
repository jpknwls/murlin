//
//  actions.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import CoreGraphics

enum AppAction {
    /* DEVICE */
    case startOrientationListening
    case startKeyboardHideListening
    case startKeyboardChangeListening
    case updateOrientation(Orientation)
    case hideKeyboard
    case setKeyboardHeight(CGRect)
    /* NODES STATE */
    /* NODE STATE */
    /* NAVIGATION */
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
