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

                    switch store.state.mode.tab {
                        case .home:  HomeView()
                        case .search:  SearchView(nodes: store.state.nodes)
                        case .node(let mode, let node):
                            NavigationStackView(store: store) {
                                NodeView(node: node)
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
        .sheet(isPresented: store.binding(
                        get: { $0.mode.sheet.isOpen },
                        tag: { isShowing in
                            if isShowing {
                                return AppAction.updateSheet(.settings)                               
                            } else {
                                return AppAction.updateSheet(.idle)
                                
                            }
                        })) {
                        
                            switch store.state.mode.sheet {
                                case .addTab: AddTabPicker() { node in
                                    store.send(action: .add(node)) // add nodeView to viewMap
                                    store.send(action: .updateTab(.node(.idle, node))) // close sheet
                                    store.send(action: .updateSheet(.idle)) // move tab to new node
                                }
                                case .settings: SettingsView()
                                
                                
                                default: EmptyView()
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
            if !store.state.device.isKeyboardOpen && !store.state.mode.tab.isSelecting {
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
        .transition(.move(edge: .top))
    }
    
    var tabBar: some View {
        HStack {
            //home
            Button(action: {
                store.send(action: .updateTab(.home(.idle)))
            }, label: {
                Image(systemName: Globals.homeIcon)
            })
            .tab()
            //search
            Button(action: {
                store.send(action: .updateTab(.search(.idle)))
            }, label: {
                Image(systemName: Globals.searchIcon)
            })
            .tab()
            Spacer()
            ZStack(alignment: .trailing) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(store.state.navigation.viewMap.values.map { $0 }) { value in
                            Button(action: {
                                store.send(action: .updateTab(.node(.idle, value.node)))
                            }, label: {
                               Text(value.node.title)
                            })
                            .tab(isNodeTab: true)

                        }
                    }
                }
                
                Button(
                        action: { store.send(action: .updateSheet(.addTab)) },
                        label: { Image(systemName: Globals.addIcon) }) //TODO: add tab action
                            .tab()

            }
        }
            .disabled(store.state.mode.sheet.isOpen)
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
                    switch store.state.mode.tab {
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
                .padding([.leading, .trailing], 4)
                .transition(.move(edge: .bottom))
        }
    }
    
    
    var searchBar: some View {
        HStack {
            TextEditView(placeholder: "Search or Add Note", text: store.binding(
                    get: { state in
                        state.nodesState.searchText
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
                if store.state.mode.tab.isSelecting {
                    store.send(action: .updateTab(.home(.idle)))
                } else {
                    store.send(action: .updateTab(.home(.selecting(.idle))))
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
           store.send(action: .updateSheet(.filterTags))
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
          store.send(action: .updateTab(.home(.selecting(.addingLink))))
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
            store.send(action: .updateTab(.home(.selecting(.addingTag))))
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
             store.send(action: .updateTab(.home(.selecting(.deleting))))
            },
            label: {
                Image(systemName: "minus")
                
            })
        .button()

    }
    var settingsButton: some View {
            Button(action: {
             store.send(action: .updateSheet(.settings))
            },
            label: {
                Image(systemName: "gearshape")
            })
        .button()

    }

    
}
