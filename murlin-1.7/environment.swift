//
//  environment.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import Combine
import UIKit
import RealmSwift

// Services like API methods go here
struct AppEnvironment {
    func startOrientationListening() -> Fx<AppAction>{
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
    
    func startKeyboardListening() -> Fx<AppAction> {
        // we should merge this with keyboardchange
        
        let keyboardChangePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardDidChangeFrameNotification)
            .map { notification -> AppAction in
                        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return AppAction.updateKeyboard(.zero)  }  // hidingKeyboard
                        let newRect = keyboardValue.cgRectValue
                        return AppAction.updateKeyboard(newRect)
                    }
                    
        let keyboardHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                    .map {_ in AppAction.updateKeyboard(.zero) } // hidingKeyboard
                    
                    
        return keyboardChangePublisher.merge(with: keyboardHidePublisher).eraseToAnyPublisher()
    }
    
    

    
//    func startKeyboardChangeListening() -> Fx<AppAction> {
//          NotificationCenter.default.publisher(for: UIResponder.keyboardDidChangeFrameNotification)
//                    .map { notification in
//                        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return AppAction.setKeyboardHeight(.zero)  }  // hidingKeyboard
//                        let newRect = keyboardValue.cgRectValue
//                        return AppAction.setKeyboardHeight(newRect)
//                    }.eraseToAnyPublisher()
//    }
//    
    /*
        updateSearchText(
            -> send this value to our environment
            -> this should trigger an update
            
             AnyPublisher<String, Never>
             -> 
             
             
    
     */
     
    let repository = Repository()
    
    
//    func queryPublisher(for text: String, sort: SortOrder) -> Fx<AppAction> {
//        if let results = queryDatabase(text: text, sort: sort) {
//            return Just(.updateQuery(results)).eraseToAnyPublisher()
//        } else {
//            return Just(.empty).eraseToAnyPublisher()
//        }
//    }
}
