//
//  RootView.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import SwiftUI
import RealmSwift



struct RootView: View {
    @ObservedObject var store: Store<AppModel, AppEnvironment, AppAction>

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                headerBar
                tabBar
                //contentView
                /*
                    home
                    search
                    node(id)
                 */
                nodeList(store.state.nodes) { node in
                    NodeCard(node: node, isSelecting: store.state.state.mode.isSelecting) {
                        store.send(action: .push(AnyView(EmptyView())))
                    }
                }
                Spacer()
            }
        
           VStack(spacing: 2) {
                toolBar
                searchBar
           }
        }
        .onAppear {
                store.send(action: .loadQuery)
        }
            .sheet(isPresented:
                store.binding(
                    get: { $0.state.mode.isAddingTags },
                    tag: { isShowing in
                        if isShowing {
                            return AppAction.updateMode(.home(.selecting(.addingTag)))
                        } else {
                            return AppAction.updateMode(.home(.selecting(.idle)))
                        }
                    })) {
//                        TagsPicker(with: currentlySelectedTags) { tags in // constrain to the tags from selection?
//                                // add tags here
//                        }
            }
            .sheet(isPresented:
                store.binding(
                    get: { $0.state.mode.isFiltering },
                    tag: { isShowing in
                        if isShowing {
                            return AppAction.updateMode(.home(.filtering))
                        } else {
                            return AppAction.updateMode(.home(.idle(.idle)))
                        }
                    })) {
                            TagsPicker(with: store.state.nodesState.filters) { tags in
                                // add tags here
                                store.send(action: .updateFilters(tags))
                            }
                        
                        
            }
            .sheet(isPresented:
                store.binding(
                    get: { $0.state.mode.isAddingLinks },
                    tag: { isShowing in
                        if isShowing {
                            return AppAction.updateMode(.home(.selecting(.addingLink)))
                        } else {
                            return AppAction.updateMode(.home(.selecting(.idle)))
                        }
                    })) {
//                        NodesPicker { nodes in
//                            // add nodes here
//                        }
            }
             .sheet(isPresented:
                store.binding(
                    get: { $0.state.mode.isInSettings },
                    tag: { isShowing in
                        if isShowing {
                            return AppAction.updateMode(.home(.settings))
                        } else {
                            return AppAction.updateMode(.home(.idle(.idle)))
                        }
                    })) {
                    BackgroundView(backgroundColor:Color.main.opacity(0.6)) {
                            SettingsView()
                    }
            }
        }
    /*
        sheet
     */
    
}



extension RootView {
        
    var headerBar: some View {
        Group {
            if !store.state.device.isKeyboardOpen && !store.state.state.mode.isSelecting {
                   HStack {
                    settingsButton
                        .padding()
                    Spacer()
                    Text("Murlin")
                        .foregroundColor(Color.main)
                        .font(.system(size: 48.0, weight: .bold, design: .rounded))
                        .padding()
                }
            }
        }
         .animation(.easeInOut)
        .transition(.move(edge: .top))
    }
    
    var tabBar: some View {
        EmptyView()
    }
    
    var toolBar: some View {
       Group {
                HStack {
                     if !store.state.nodesState.searchText.isEmpty {
                        addNodeButton
                        .disabled(store.state.nodesState.searchText.isEmpty)
                        .padding(4)
                    }
                    selectButton
                    switch store.state.state.mode {
                        case .home(let mode):
                            switch mode {
                                case .idle:
                                     sortSelect
                                    filterButton
                                case .selecting:
                                
                                    addNodesButton
                                    addTagsButton
                                    deleteNodesButton
                                default:
                                    EmptyView()
                                 
                            }
                        default: EmptyView()
                    }
                    
                }
        }
        .padding([.leading, .trailing], 4)
        .animation(.spring())
        .transition(.move(edge: .bottom))
    }
    
    
    var searchBar: some View {
        HStack {
            TextEditView(placeholder: "Search or Add Note", text: store.binding(
                    get: { state in
                        state.nodesState.searchText ?? ""
                    },
                    tag: { newText in AppAction.updateSearchText(newText) } )
            )
            
            .padding(8)
            .background(
                ZStack {
                     RoundedRectangle(cornerRadius: 10.0)
                        .foregroundColor(.white)
                     RoundedRectangle(cornerRadius: 10.0)
                        .foregroundColor(Color.main.opacity(0.4))
                }
               
            )
        }.animation(.spring())
    }
    
    var selectButton: some View {
            Button(action: {
                if store.state.state.mode.isSelecting {
                    store.send(action: .updateMode(.home(.idle(.idle))))
                } else {
                    store.send(action: .updateMode(.home(.selecting(.idle))))
                }
            },
            label: {
                Image(systemName: "lasso.sparkles")
            })
            .button()
    }
    var filterButton: some View {
         // tag picker, pass in previously filtered tags
          // button
        Button(action: {
           store.send(action: .updateMode(.home(.filtering)))
        },
        label: {
            Image(systemName: "line.horizontal.3")
            
        })
        .button()

        
    }

    
    var sortSelect: some View {
        // context menu?
        Menu {
            // alphabetical up
            Button(action: {
                store.send(action: .updateSortOrder(.alphabetical(true)))
            }) {
                Label("A-Z", systemImage: "arrow.up.doc")
            }
            // alphabetical down
            Button(action: {
                store.send(action: .updateSortOrder(.alphabetical(false)))
            }) {
                Label("Z-A", systemImage: "arrow.down.doc")
            }
            Button(action: {
                store.send(action: .updateSortOrder(.createdAge(false)))
                
            }) {
                Label("Newest", systemImage: "calendar.circle")
            }
            Button(action: {
                 store.send(action: .updateSortOrder(.createdAge(false)))
            }) {
                Label("Oldest", systemImage: "calendar.circle.fill")
            }
            
            Button(action: {
               store.send(action: .updateSortOrder(.updatedAge(true)))
            }) {
                Label("Recently Updated", systemImage: "calendar.badge.clock")
            }
            
        } label: {
            Image(systemName: "arrow.up.and.down")
                .button()
        }
    }
    
    var addNodeButton: some View {
        Button(action: {
            //store.send(action: .addNode)
          //  guard let node = store.state.newlyCreatedNode else { return }
            //DispatchQueue.main.async {
          ///      navigation.push(Delegate.shared.getNodeView(for: node), withId: node.uuid.uuidString)
                
          //  }
        },
        label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .heavy))
            
        })
        .button()

        
    }
    var addNodesButton: some View {
        Button( action: {
          store.send(action: .updateMode(.home(.selecting(.addingLink))))
            },
            label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Nodes")
                }
            })
            .button()
    
    }
    var addTagsButton: some View {
          Button( action: {
            store.send(action: .updateMode(.home(.selecting(.addingTag))))
            },
            label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Tags")
                }
            })
        .button()

    }
    var deleteNodesButton: some View {
         Button( action: {
             store.send(action: .updateMode(.home(.selecting(.deleting))))
            },
            label: {
                Image(systemName: "minus")
                
            })
        .button()

    }
    var settingsButton: some View {
            Button(action: {
             store.send(action: .updateMode(.home(.settings)))
            },
            label: {
                Image(systemName: "gearshape")
            })
        .button()

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
