//
//  StateTree.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation

// add data into modes???
enum SheetMode: Equatable {
    case settings
    case history
    case backlinks
    case addTab
    case addNodes
    case addTags
    case filterTags
    case showTag
    case clips
    case idle
}

enum TabMode: Equatable {
    case home(HomeMode)
    case search(SearchMode)
    case node(NodeMode, Node)
}

enum HomeMode: Equatable {
    case idle
    case selecting(SelectingMode)
    case focusing
    case deleting
}

enum NodeMode: Equatable {
    case idle
    case selecting(SelectingMode)
    case editing
    case focusing
    case deleting
}

enum SearchMode: Equatable {
    case idle
    case selecting(SelectingMode)
    case focusing
}


enum SelectingMode: Equatable {
  case idle
  case deleting
  case addingTag
  case addingLink
}

//convenience accessors
extension SheetMode {
    var isInSettings: Bool {
        switch self {
            case .settings: return true
            default: return false
        }
    }
    
    var isFiltering: Bool {
        switch self {
            case .filterTags: return true
            default: return false
        }
    }
    
    var isAddingLinks: Bool {
        switch self {
            case .addNodes: return true
            default: return false
        }
    }
    
    var isAddingTags: Bool {
         switch self {
            case .addTags: return true
            default: return false
        }
    }
    
    var isAddingTab: Bool {
        switch self {
            case .addTab: return true
            default: return false
        }
    }
    
    var isOpen: Bool {
        switch self {
            case .idle: return false
            default: return true
        }
    }
}

extension TabMode {
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
                    case .selecting(_): return true
                    default: return false
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
    
