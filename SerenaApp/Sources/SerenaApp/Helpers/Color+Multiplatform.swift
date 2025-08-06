import SwiftUI

extension Color {
    static let bgColor: Color = {
#if os(iOS)
    Color(uiColor: .systemBackground)
#elseif os(macOS)
    Color(NSColor.controlBackgroundColor)
#endif
    }()
}
