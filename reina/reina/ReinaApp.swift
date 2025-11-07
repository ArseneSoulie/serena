//
//  ReinaApp.swift
//  reina
//
//  Created by A S on 06/08/2025.
//

import DesignSystem
import Kana
import ReinaDB
import SwiftUI
import Typist

@main
struct ReinaApp: App {
    init() {
        registerFontForUIKitComponents()
        prepareReinaDB(at: DatabaseLocator.reinaDatabaseURL)
    }

    var body: some Scene {
        WindowGroup {
            KanaMainPage()
                .registerFontForSwiftUIComponents()
        }
    }
}
