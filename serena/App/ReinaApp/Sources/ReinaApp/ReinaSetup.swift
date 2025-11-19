import DesignSystem
import ReinaDB
import Typist

@MainActor
public func setupReina() {
    registerFontForUIKitComponents()
    prepareReinaDB(at: DatabaseLocator.reinaDatabaseURL)
}
