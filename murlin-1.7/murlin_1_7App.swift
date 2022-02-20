//
//  murlin_1_7App.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import SwiftUI
import os
import RealmSwift

@main
struct murlin_1_7App: SwiftUI.App {

    @ObservedObject var store: Store<AppModel, AppEnvironment, AppAction>
    
    init() {
        let environment = AppEnvironment()
        var state = AppModel()
        let logger = Logger()
        self.store = Store<AppModel, AppEnvironment, AppAction>(update: AppModel.update, state: state, environment: environment, logger: logger)
    }
    var body: some Scene {
        WindowGroup {
            NavigationStackView(store: store) {
               RootView(store: store)
            }
            .environment(\.realmConfiguration, Realm.config)
            .gradientBacking(color: Color.main)
            .onAppear {
                //loadRandomData()
                store.send(action: .startKeyboardChangeListening)
                store.send(action: .startKeyboardHideListening)
                store.send(action: .startOrientationListening)
            }
        }
    }
}


/*

        RootView
            headerBar
                [ settings, history, Murlin ]    -> open top-level sheets
            tabBar
                [ home, search, [openTabs] ]     -> change top-level mode
            content
                [ openTab ]                       -> interact with content
                
                    home
                        list of newly created blocks/nodes
                        list of recently updated nodes
                        list of pinned nodes
                    
                    search
                        list of node cards
                        
                    
                    node(id)
                        title
                        blockTree
                        nodeList
                
            toolBar
                [ select, add, filter, sort, addTag, addLink, delete]  -> CRUD & find
            searchBar
                [ maybe put add here, remove? ]  -> typing surface
        
        
        
        sheets
            tagPicker
                tagWall
                    tagCard
                
            nodePicker
                nodeList
                    nodeCard
                
            settings
                form
                
            history
                nodeList
                    nodeCard
            
            backlinks
                nodeList
                    nodeCard
        
        containers
        
            nodeList
                use ScrollView, LazyVStack for search results
                use List for node.links
                
            blockTree?
                .....
            
            tabBar
                just use ScrollView, HStack
                
            tagWall
                use https://www.fivestars.blog/articles/flexible-swiftui/
               
        cards
            
            tab
                display a node title (fades out after n characters)
            
            tag
                displays a tag name (full name)
            
            block
                displays block text
            
            node
                displays node name,
                some of nodes blocks,
                maybe info about number and type of links,
                shows some tags (maybe do a scrolling or expandable view)
              
              
    
    
    
    
    to add:
        - history
        - tabs
        - currentTab (is this just mode??)
        -
 */
