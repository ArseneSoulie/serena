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
        }
    }
}
