//
//  NodesView.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import SwiftUI
import RealmSwift

struct NodesView: View {
    @ObservedObject var store: Store<AppModel, AppEnvironment, AppAction>
    //@ObservedResults(Node.self) var nodes
    
    var resultsFilter: NSCompoundPredicate {
        var predicates: [NSPredicate] = []
        if let searchState = store.state.searching[store.state.rootID] {
            if !searchState.filters.isEmpty {
                // filter the nodes
                }
                if !searchState.searchText.isEmpty {
                    let text = searchState.searchText
                    let titlePred = NSPredicate(format: "title beginswith %@", text)
                    let notePred = NSPredicate(format: "note beginswith %@", text)
                    predicates.append(titlePred)
                    predicates.append(notePred)
                   // procNodes = procNodes.filter(compoundPred)
                }
        }
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    


    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                headerBar
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
                            return AppAction.updateMode(.nodes(.selecting(.addingTag)))
                        } else {
                            return AppAction.updateMode(.nodes(.selecting(.idle)))
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
                            return AppAction.updateMode(.nodes(.filtering))
                        } else {
                            return AppAction.updateMode(.nodes(.idle(.idle)))
                        }
                    })) {
                        if let filterState = store.state.searching[store.state.rootID]?.filters {
                            TagsPicker(with: filterState) { tags in
                                // add tags here
                                store.send(action: .updateFilters(tags))
                            }
                        }
                        
            }
            .sheet(isPresented:
                store.binding(
                    get: { $0.state.mode.isAddingLinks },
                    tag: { isShowing in
                        if isShowing {
                            return AppAction.updateMode(.nodes(.selecting(.addingLink)))
                        } else {
                            return AppAction.updateMode(.nodes(.selecting(.idle)))
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
                            return AppAction.updateMode(.nodes(.settings))
                        } else {
                            return AppAction.updateMode(.nodes(.idle(.idle)))
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



extension NodesView {
        
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
        
        var toolBar: some View {
           Group {
                    HStack {
                         if let search = store.state.searching[store.state.rootID]?.searchText, !search.isEmpty {
                            addNodeButton
                            .disabled(search.isEmpty)
                            .padding(4)
                        }
                        selectButton
                        switch store.state.state.mode {
                            case .nodes(let mode):
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
                            state.searching[state.rootID]?.searchText ?? ""
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
                        store.send(action: .updateMode(.nodes(.idle(.idle))))
                    } else {
                        store.send(action: .updateMode(.nodes(.selecting(.idle))))
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
               store.send(action: .updateMode(.nodes(.filtering)))
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
              store.send(action: .updateMode(.nodes(.selecting(.addingLink))))
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
                store.send(action: .updateMode(.nodes(.selecting(.addingTag))))
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
                 store.send(action: .updateMode(.nodes(.selecting(.deleting))))
                },
                label: {
                    Image(systemName: "minus")
                    
                })
            .button()

        }
        var settingsButton: some View {
                Button(action: {
                 store.send(action: .updateMode(.nodes(.settings)))
                },
                label: {
                    Image(systemName: "gearshape")
                })
            .button()

        }
        
        func nodeList(_ nodes: [NodeProjection], content: @escaping (NodeProjection) -> (NodeCard)) -> some View {
            //var procNodes = nodes.filter(resultsFilter)
           // var procNodes =
//            if let searchState = store.state.searching[store.state.rootID] {
//                procNodes = procNodes.where {
//                        $0.title.contains(searchState.searchText)
//                }
//

//            }
//

                        
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
