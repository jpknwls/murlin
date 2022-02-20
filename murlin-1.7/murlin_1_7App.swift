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
               NodesView(store: store)
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
