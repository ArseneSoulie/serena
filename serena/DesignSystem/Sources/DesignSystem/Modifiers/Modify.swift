//
//  Modify.swift
//  DesignSystem
//
//  Created by A S on 14/11/2025.
//

import SwiftUI

public extension View {
    func modify<Content>(
        @ViewBuilder _ transform: (Self) -> Content,
    ) -> Content {
        transform(self)
    }
}

extension ToolbarContent {
    func modify<Content>(
        @ToolbarContentBuilder _ transform: (Self) -> Content,
    ) -> Content {
        transform(self)
    }
}
