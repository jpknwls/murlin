//
//  TabPicker.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/22/22.
//

import Foundation
import SwiftUI
import RealmSwift

struct AddTabPicker: View {
    @ObservedResults(Node.self) var nodes
    @State var search: String = ""
    
    let select: (Node) -> ()
    
    var body: some View {
        BackgroundView(backgroundColor:Color.main.opacity(0.6)) {
            VStack {
                list
                Spacer()
                searchBar
            }
        }
       
    }
    
    var list: some View {
        var processed = nodes
        if !search.isEmpty {
            processed = processed.filter("title contains[c] %@", search)

        }
        return ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(processed) { node in
                    VStack {
                        Text(node.title)
                            .padding()
                            .gradientBacking(color: Color.main.opacity(0.5))
                            .onTapGesture {
                                select(node)
                            }
                    }
                }
            }
        }
    }
    
    var searchBar: some View {
           TextField("Search...", text: $search)
                    .padding()
    }
}
