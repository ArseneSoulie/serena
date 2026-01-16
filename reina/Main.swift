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
                .environment(
                    \.locale,
                    Bundle.main.preferredLocalizations.first.flatMap(Locale.init(identifier:)) ?? Locale.current,
                )
        }
    }
}
