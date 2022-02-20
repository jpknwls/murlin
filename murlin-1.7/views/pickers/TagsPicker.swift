//
//  TagsPicker.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/20/22.
//

import Foundation
import SwiftUI
import RealmSwift
/*
    used in:
        Root: we add a set of tags to our selection
        Node: we modify the set of tags to our selected node
 
 
    callback
        we send back the set of tags that we have selected
        
    
    
 */
 
 struct TagsPicker: View {
    @ObservedResults(Tag.self) var tags
    @State var selectedTags: Set<Tag> = []
    @State var searchText: String = ""
    
    let confirm: (Set<Tag>) -> ()
    
    init(with tags: Set<Tag>, confirm: @escaping (Set<Tag>) -> ()) {
        self.confirm = confirm
        self.selectedTags = tags
    }

    var body: some View {
            VStack {
                HStack {
                    cancelButton
                    Spacer()
                    confirmButton
                }
                tagsGrid()
                searchBar
            }
         
    }
    
    var cancelButton: some View { EmptyView() }
    var confirmButton: some View { EmptyView() }
    var searchBar: some View {
        TextField("Search...", text: $searchText)
    }
    func tagsGrid() -> some View {
        var filteredTags = tags
        if !searchText.isEmpty {
            filteredTags = filteredTags.filter("name CONTAINS[c] %@", searchText)
        }
        return GridPicker(tags: filteredTags.map { $0 }, selectedTags: $selectedTags)
    }
 }


struct GridPicker: View {
    let tags: [Tag]
    var rows: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @Binding var selectedTags: Set<Tag>
    
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows) {
                    ForEach(tags, id: \.self) { item in
                        GridColumn(tag: item, selectedTags: $selectedTags)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct GridColumn:View {
    let tag: Tag
    
    @Binding var selectedTags: Set<Tag>
    
    var body: some View {
        Button(action: {
            if selectedTags.contains(tag) {
                selectedTags.remove(tag)
            } else {
                selectedTags.insert(tag)
            }
        }, label: {
            Text(tag.name)
                .tag(tag.uuid)
                .foregroundColor(selectedTags.contains(tag) ? .purple : .white)
        })
        
        .frame(width: 85, height: 85)
        .background(selectedTags.contains(tag) ? Color.white : Color.purple)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
