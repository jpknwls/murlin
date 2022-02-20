//
//  NavigationView.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//
import SwiftUI

/// An alternative SwiftUI NavigationView implementing classic stack-based navigation giving also some more control on animations and programmatic navigation.
struct NavigationStackView<Root>: View where Root: View {
    @ObservedObject var store: Store<AppModel, AppEnvironment, AppAction>
    
    let rootView: Root
    let transitions: (push: AnyTransition, pop: AnyTransition)

    /// Creates a NavigationStackView.
    /// - Parameters:
    ///   - transitionType: The type of transition to apply between views in every push and pop operation.
    ///   - easing: The easing function to apply to every push and pop operation.
    ///   - rootView: The very first view in the NavigationStack.
    init(transitionType: NavigationTransition = .default,
                store:Store<AppModel, AppEnvironment, AppAction>,
                easing: Animation = NavigationState.defaultEasing,
                @ViewBuilder rootView: () -> Root) {

        self.init(transitionType: transitionType,
                  store: store,
                  rootView: rootView)
    }

    /// Creates a NavigationStackView with the provided NavigationStack
    /// - Parameters:
    ///   - transitionType: The type of transition to apply between views in every push and pop operation.
    ///   - navigationStack: the shared NavigationStack
    ///   - rootView: The very first view in the NavigationStack.
    init(transitionType: NavigationTransition = .default,
                store:Store<AppModel, AppEnvironment, AppAction>,
                @ViewBuilder rootView: () -> Root) {

        self.rootView = rootView()
        self.store = store
        switch transitionType {
        case .none:
            self.transitions = (.identity, .identity)
        case .custom(let trans):
            self.transitions = (trans, trans)
        default:
            self.transitions = NavigationTransition.defaultTransitions
        }
    }

    var body: some View {
        let showRoot = store.state.navigation.currentView == nil
        let navigationType = store.state.navigation.navigationType

        return ZStack {
            Group {
                if showRoot {
                    rootView
                        .transition(navigationType == .push ? transitions.push : transitions.pop)
                        .environmentObject(store)
                } else {
                    store.state.navigation.currentView!.wrappedElement
                        .transition(navigationType == .push ? transitions.push : transitions.pop)
                        .environmentObject(store)
                }
            }
        }
    }
}
