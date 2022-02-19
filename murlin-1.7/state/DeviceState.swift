//
//  DeviceState.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import CoreGraphics

struct DeviceState: Equatable {
    var orientation: Orientation = .portrait
    var keyboard: CGRect? = .zero
    
    var isKeyboardOpen: Bool {
        keyboard != .zero ? true : false
    }
}
