//
//  ReinaApp.swift
//  reina
//
//  Created by A S on 06/08/2025.
//

import Kana
import Navigation
import SwiftUI

@main
struct ReinaApp: App {
    var coordinator = NavigationCoordinator()

    var body: some Scene {
        WindowGroup {
            KanaMainPage()
                .environment(coordinator)
        }
    }
}
