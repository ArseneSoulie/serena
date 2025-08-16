//
//  ConfettiView.swift
//  SerenaApp
//
//  Created by A S on 06/08/2025.
//

import SwiftUI

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var x: CGFloat = 0
    var y: CGFloat = 0
    var angle: Angle
    var speed: CGFloat
    var rotation: Double
    var color: Color
}

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    let colors: [Color] = [.red, .blue, .green, .orange, .yellow, .purple]
    let count: Int
    let emitPoint: CGPoint

    @State var isHidden: Bool = false

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Rectangle()
                    .fill(particle.color)
                    .frame(width: 8, height: 8)
                    .rotationEffect(.degrees(particle.rotation))
                    .position(x: particle.x, y: particle.y)
                    .transition(.scale)
            }
        }
        .onAppear {
            launchParticles()
        }
        .opacity(isHidden ? 0 : 1)
    }

    private func launchParticles() {
        isHidden = false
        let initialParticles = (0 ..< count).map { _ in
            ConfettiParticle(
                x: emitPoint.x,
                y: emitPoint.y,
                angle: Angle(degrees: Double.random(in: 60 ... 120)),
                speed: CGFloat.random(in: 300 ... 700),
                rotation: Double.random(in: 0 ... 360),
                color: colors.randomElement()!,
            )
        }

        particles = initialParticles

        // Animate outward
        withAnimation(.easeOut(duration: 4)) {
            for index in particles.indices {
                let angle = particles[index].angle
                let dx = cos(angle.radians) * particles[index].speed
                let dy = sin(angle.radians) * particles[index].speed + 100

                particles[index].x += dx
                particles[index].y += dy
                particles[index].rotation += Double.random(in: 360 ... 1080)
            }
            isHidden = true
        }
    }
}
