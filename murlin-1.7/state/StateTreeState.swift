//
//  StateTreeState.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation

struct ModeTree: Equatable {
    var tab: TabMode = .home(.idle)
    var sheet: SheetMode = .idle
}
