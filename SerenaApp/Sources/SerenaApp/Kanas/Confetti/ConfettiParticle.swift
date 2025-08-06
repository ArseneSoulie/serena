//
//  ConfettiParticle.swift
//  SerenaApp
//
//  Created by A S on 05/08/2025.
//


import SwiftUI

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var color: Color
    var xOffset: CGFloat
    var yOffset: CGFloat
    var angle: Angle
    var scale: CGFloat
}
