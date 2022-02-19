//
//  StateTree.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
/*
    state tree
    
    enum RootMode {
   case base
   case selecting
   case deleting
   case settings
   case editingFilter
   case addingTags
   case addingNodes
}

enum NodeMode {
   case base
   case editing
   case deleting
   case showingTags
   case showingNodes
   case showingBacklinks
}

 */
 
enum Mode: Equatable {
    case nodes(NodesMode)
    case node(NodeMode)
}

enum NodesMode: Equatable {
    case idle
}

enum NodeMode: Equatable {
    case idle
}
