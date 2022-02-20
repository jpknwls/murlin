//
//  NavigationState.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import SwiftUI

struct NavigationState: Equatable {
    static let defaultEasing = Animation.easeOut(duration: 0.2)
    var currentView: ViewElement?
    var navigationType = NavigationType.push
    let easing: Animation
    var viewStack = ViewStack() {
        didSet {
            currentView = viewStack.peek()
        }
    }
    /// The current depth of the navigation stack.
    /// Root has depth = 0
    var depth: Int { viewStack.depth }
  
}

extension NavigationState {
    public init(easing: Animation = defaultEasing) {
        self.easing = easing
    }
}

    


    /// Navigates to a view.
    /// - Parameters:
    ///   - element: The destination view.
    ///   - identifier: The ID of the destination view (used to easily come back to it if needed).


//the actual stack
struct ViewStack: Equatable {
    private var views = [ViewElement]()
    var depth: Int { views.count }
}


extension ViewStack {
    func peek() -> ViewElement? {
        views.last
    }

    mutating func push(_ element: ViewElement) {
        guard indexForView(withId: element.id) == nil else {
            print("Duplicated view identifier: \"\(element.id)\". You are trying to push a view with an identifier that already exists on the navigation stack.")
            return
        }
        views.append(element)
    }

    mutating func popToPrevious() {
        _ = views.popLast()
    }

    mutating func popToView(withId identifier: String) {
        guard let viewIndex = indexForView(withId: identifier) else {
            print("Identifier \"\(identifier)\" not found. You are trying to pop to a view that doesn't exist.")
            return
        }
        views.removeLast(views.count - (viewIndex + 1))
    }

    mutating func popToRoot() {
        views.removeAll()
    }

    private func indexForView(withId identifier: String) -> Int? {
        views.firstIndex {
            $0.id == identifier
        }
    }
}
