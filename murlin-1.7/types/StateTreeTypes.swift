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
    case node(NodeMode, Node)
}

enum NodesMode: Equatable {
    case idle(IdleMode)
    case selecting(SelectingMode)
    case filtering
    case settings
}

enum NodeMode: Equatable {
    case idle(IdleMode)
    case selecting(SelectingMode)
    case editing
    case filtering
}

enum IdleMode: Equatable {
    case idle
    case deleting
}

enum SelectingMode: Equatable {
  case idle
  case deleting
  case addingTag
  case addingLink
}

//convenience accessors
extension Mode {
    var isInSettings: Bool {
        switch self {
            case .nodes(let mode):
                switch mode {
                    case .settings: return true
                    default: return false
                }
            default: return false
        }
    }
    
    var isFiltering: Bool {
        switch self {
            case .nodes(let mode):
                switch mode {
                    case .filtering: return true
                    default: return false
                }
            default: return false
        }
    }
    
    var isAddingLinks: Bool {
        switch self {
            case .nodes(let mode):
                switch mode {
                    case .selecting(let mode):
                        switch mode {
                            case .addingLink: return true
                            default: return false
                        }
                    default: return false
                }
            default: return false
        }
    }
    
    var isAddingTags: Bool {
         switch self {
            case .nodes(let mode):
                switch mode {
                    case .selecting(let mode):
                        switch mode {
                            case .addingTag: return true
                            default: return false
                        }
                    default: return false
                }
            default: return false
        }
    }
    
       var isSelecting: Bool {
        switch self {
            case .nodes(let mode):
                switch mode {
                    case .selecting(_): return true
                    default: return false
                }
            case .node(let mode, _):
                switch mode {
                    case .selecting(_): return true
                    default: return false
                }
        }
   }
   
   var isEditing: Bool {
     switch self {
            case .nodes(_):
               return false
            case .node(let mode, _):
                switch mode {
                    case .editing: return true
                    default: return false
                }
        }
   }
    
}
    
