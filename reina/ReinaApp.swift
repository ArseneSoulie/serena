import DesignSystem
import ReinaApp
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
            ReinaMainPage()
                .registerFontForSwiftUIComponents()
        }
    }
}
