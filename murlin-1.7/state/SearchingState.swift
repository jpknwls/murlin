//
//  SearchingState.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation

struct NodeSearchState: Equatable {
    var searchText: String = ""
    var filters: Set<Tag> = []
    var selection: Set<Node>  = []
    var sort: SortOrder = .updatedAge(false)
}
