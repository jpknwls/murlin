//
//  NavigationTypes.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import SwiftUI

enum NavigationType: Equatable {
    case push
    case pop
}

/// The transition type for the whole NavigationStackView.
public enum NavigationTransition: Equatable {
    public static func == (lhs: NavigationTransition, rhs: NavigationTransition) -> Bool {
        switch lhs {
            case .default:
                switch rhs {
                    case .default: return true
                    default: return false
                }
            case .custom(let transition):
                switch rhs {
                    case .custom(let transitionCompare):
                       return true
                    default: return false
                }
            case .none:
                switch rhs {
                    case .none: return true
                    default: return false
                }
        }
    }
    
    /// Transitions won't be animated.
    case none

    /// Use the [default transition](x-source-tag://defaultTransition).
    case `default`

    /// Use a custom transition (the transition will be applied both to push and pop operations).
    case custom(AnyTransition)

    /// A right-to-left slide transition on push, a left-to-right slide transition on pop.
    /// - Tag: defaultTransition
    public static var defaultTransitions: (push: AnyTransition, pop: AnyTransition) {
        let pushTrans = AnyTransition.asymmetric(insertion: .move(edge: .trailing),
                                                 removal: .move(edge: .leading).combined(with: .opacity))
        let popTrans = AnyTransition.asymmetric(insertion: .move(edge: .leading),
                                                removal: .move(edge: .trailing).combined(with: .opacity))
        return (pushTrans, popTrans)
    }
}

/// Defines the type of a pop operation.
public enum PopDestination: Equatable {
    /// Pop back to the previous view.
    case previous

    /// Pop back to the root view (i.e. the first view added to the NavigationStackView during the initialization process).
    case root

    /// Pop back to a view identified by a specific ID.
    case view(withId: String)
}





//the actual element in the stack
struct ViewElement: Identifiable, Equatable {
    let id: String
    let wrappedElement: AnyView

    static func == (lhs: ViewElement, rhs: ViewElement) -> Bool {
        lhs.id == rhs.id
    }
}
