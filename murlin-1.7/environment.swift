//
//  environment.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import Combine

// Services like API methods go here
struct AppEnvironment {
    func startOrientationListening() -> AnyPublisher<AppAction, Never> {
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                    .compactMap { ($0.object as? UIDevice)?.orientation }
                    .compactMap { deviceOrientation -> Orientation? in
                        if deviceOrientation.isPortrait {
                            return .portrait
                        } else if deviceOrientation.isLandscape {
                            return .landscape
                        } else {
                            return nil
                        }
                    }.map { orientation in
                        AppAction.updateOrientation(orientation)
                    }.eraseToAnyPublisher()
    }
    
    func startKeyboardListening() -> AnyPublisher<AppAction, Never> {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                    .map {_ in AppAction.hideKeyboard }
                    .eraseToAnyPublisher()
    }
}
