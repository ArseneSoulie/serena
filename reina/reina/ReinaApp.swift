//
//  ReinaApp.swift
//  reina
//
//  Created by A S on 06/08/2025.
//

import DesignSystem
import Kana
import Navigation
import SwiftUI

@main
struct ReinaApp: App {
    init() {
        registerFontForUIKitComponents()
    }

    var body: some Scene {
        WindowGroup {
            KanaMainPage()
                .registerFontForSwiftUIComponents()
        }
    }
}
