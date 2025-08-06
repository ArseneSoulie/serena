//
//  reinaApp.swift
//  reina
//
//  Created by A S on 06/08/2025.
//

import SwiftUI
import Kana
import Navigation

@main
struct ReinaApp: App {
    var coordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            KanaSelectionPage()
                .environment(coordinator)
        }
    }
}
