//
//  SettingsView.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation
import SwiftUI
class SettingsModel: ObservableObject {
    @Published var color: Color {
       willSet {
            UserDefaults.standard.set(UIColor(cgColor: color.cgColor ?? CGColor.init(red: 0, green: 0, blue: 0, alpha: 0)), forKey: "color")
        }
    }
    
    init() {
        // load color from defaults
         self.color = Color(UserDefaults.standard.color(forKey: "color") ?? UIColor.gray)
    }
}


struct SettingsView: View {
    var body: some View {
        VStack {
            Spacer()
        }.gradientBacking(color: Color.main.opacity(0.7))
    }
}
