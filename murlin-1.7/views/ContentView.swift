//
//  ContentView.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store<AppModel, AppEnvironment, AppAction>

    var body: some View {
        VStack {
            Button(
                action: {
                    store.send(action: .push(AnyView(OtherView(store: store)))) },
                label: { Text("GO")})
            .padding()
            
            Button(
                action: {
                    store.send(action: .empty) },
                label: { Text("NIL")})
            .padding()
        }
            
    }
}

struct OtherView: View {
        @ObservedObject var store: Store<AppModel, AppEnvironment, AppAction>
    var body: some View {
          Button(
            action: {
                store.send(action: .pop()) },
            label: { Text("Back")})
            .padding()
        }
}


