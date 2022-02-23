//
//  NodeView.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/20/22.
//

import Foundation
import SwiftUI
import RealmSwift


struct NodeView: View {
    @ObservedRealmObject var node: Node
    
    var body: some View {
        Text(node.title)
    }
}
