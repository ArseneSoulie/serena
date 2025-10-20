//
//  Models.swift
//  Typist
//
//  Created by A S on 17/10/2025.
//

import Foundation

struct TextToType: Equatable, Identifiable {
    // Conforming to Identifiable is good practice for ForEach loops.
    let id = UUID()
    let value: String
    let x: Double
    var y: Double
}

struct ScorePopup: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let x: Double
    let y: Double
    var opacity: Double = 1.0
    var offsetY: CGFloat = 0
}
