//
//  StateTree.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation


enum Mode: Equatable {
    case home(HomeMode)
    case search(SearchMode)
    case node(NodeMode, Node)
}

enum HomeMode: Equatable {
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

enum SearchMode: Equatable {
    case idle
    case selecting(SelectingMode)
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
            case .home(let mode):
                switch mode {
                    case .settings: return true
                    default: return false
                }
            default: return false
        }
    }
    
    var isFiltering: Bool {
        switch self {
            case .home(let mode):
                switch mode {
                    case .filtering: return true
                    default: return false
                }
            default: return false
        }
    }
    
    var isAddingLinks: Bool {
        switch self {
            case .home(let mode):
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
            case .home(let mode):
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
            case .home(let mode):
                switch mode {
                    case .selecting(_): return true
                    default: return false
                }
            case .node(let mode, _):
                switch mode {
                    case .selecting(_): return true
                    default: return false
                }
            case .search(let mode):
                switch mode {
                    case .idle: return false
                    case .selecting(_): return true
                }
        }
   }
   
   var isEditing: Bool {
     switch self {
            case .home(_):
               return false
            case .node(let mode, _):
                switch mode {
                    case .editing: return true
                    default: return false
                }
            case .search: return false
        }
   }
    
}
    
