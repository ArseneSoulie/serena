import ReinaApp
import SwiftUI

@main
struct Main: App {
    init() {
        setupReina()
    }

    var body: some Scene {
        WindowGroup {
            ReinaMainPage()
                .environment(\.locale, Locale(identifier: Bundle.main.preferredLocalizations.first ?? "en"))
        }
    }
}
