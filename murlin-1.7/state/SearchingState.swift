//
//  SearchingState.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation

struct NodesSearchState: Equatable {
    var searchText: String = ""
    var filters: Set<Tag> = []
    var selection: Set<Node>  = []
    var sort: SortOrder = .updatedAge(false)
}


struct NodeSearchState: Equatable {
    var searchText: String = ""
    var filters: Set<Tag> = []
    var linkSelection: Set<Node>  = []
    //var blockSelection: Set<Block>  = []
    var sort: SortOrder = .updatedAge(false)
}
