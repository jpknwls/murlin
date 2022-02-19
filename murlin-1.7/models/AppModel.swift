//
//  AppModel.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import Combine
import UIKit

struct AppModel: Equatable {
    var state = StateTree()
    var device = DeviceState()
    var navigation = NavigationState()
    var searching = Dictionary<UUID, NodeSearchState>()

    static func update(
        model: AppModel,
        environment: AppEnvironment,
        action: AppAction
    ) -> Update<AppModel, AppAction> {
        switch action {
            /*
                    DEVICE
             */
             
            case .startOrientationListening:
                return Update(
                    state: model,
                    fx: environment.startOrientationListening())
         
            case .updateOrientation(let newOrientation):
                var update = model
                update.device.orientation = newOrientation
                return Update(state: update)
            
            
            case .startKeyboardHideListening:
                return Update(
                        state: model,
                        fx: environment.startKeyboardListening())
 
            case .hideKeyboard:
                var update = model
                update.device.keyboard = .zero
                return Update(state: update)

            case .setKeyboardHeight(let newRect):
                var update = model
                if newRect.origin.y >= UIScreen.main.bounds.height {
                    update.device.keyboard = .zero
                } else {
                    update.device.keyboard = newRect
                }
                return Update(state: update)

        
            default:
                return Update(state: model)
        }
    }
}
