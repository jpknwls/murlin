//
//  SearchView.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/20/22.
//

import Foundation
import SwiftUI
import RealmSwift


struct SearchView: View {
       
    let nodes: [NodeProjection]
    var body: some View {
        nodeList(nodes) { node in
            NodeCard(node: node, isSelecting: false) {
              // visit card
              // maybe we need to observed the store here...
            }
        }
    }
    
    func nodeList(_ nodes: [NodeProjection], content: @escaping (NodeProjection) -> (NodeCard)) -> some View {
        return ScrollView {
            LazyVStack {
                ForEach(nodes, id: \.self.uuid) { node in
                    content(node)
                    //.frame(height: 60)
                        .padding([.bottom], 4)
                    //.cornerRadius(10.0)
                }
            }
        }
    }
}
