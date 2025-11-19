//
//  DebugBorderModifier.swift
//  DesignSystem
//
//  Created by A S on 14/11/2025.
//

import SwiftUI

public extension View {
    /// A visual debugger to see redraws of swiftUI views
    /// This will be stripped at compile time if you forget to remove it on release
    /// To use it add the ``._debugBorder()`` modifier in any view where you want to visualize a recomputation
    func _debugBorder() -> some View {
        #if DEBUG
            modifier(DebugBorderModifier())
        #else
            self
        #endif
    }
}

struct DebugBorderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.border(Color.random(), width: 3)
    }
}

private extension Color {
    static func random() -> Color {
        .init(red: .random(in: 0 ... 1), green: .random(in: 0 ... 1), blue: .random(in: 0 ... 1))
    }
}
