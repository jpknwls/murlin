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
import LinkPresentation

enum AppAction {
    /* DEVICE */
    case startOrientationListening
    case startKeyboardListening
    case updateOrientation(Orientation)
    case updateKeyboard(CGRect)
    
    /* NAVIGATION */
    case add(Node) // view, id, title (for tab)
    case go(PopDestination = .previous)
    case remove(String)
    
    /* MODE */
    case updateTab(TabMode)
    case updateSheet(SheetMode)
    
    /* CACHE */
    case addLinkMetadataKey(URL)
    case setLinkMetadata(String, LPLinkMetadata)
    
    /* FOCUS*/
    case updateFocus(Node?)
    
    /* FIND STATE */
    case updateSearchText(String)
    case updateQuery([NodeProjection], String)
    case updateSortOrder(SortOrder)
    case updateFilters(Set<Tag>)
    
    /* QUERY STATE*/
    case loadQuery
    
    
    /* DATA BASE */
    
    
    
    
    /* CLIPS */
    /* HISTORY */
    //case removeFromHistory(Node)
    /* NODES STATE */
    /* NODE STATE */

    
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
