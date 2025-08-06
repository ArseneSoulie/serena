//
//  ConfettiView.swift
//  SerenaApp
//
//  Created by A S on 05/08/2025.
//
import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(particle.scale)
                    .rotationEffect(particle.angle)
                    .offset(x: particle.xOffset, y: particle.yOffset)
                    .opacity(isAnimating ? 1 : 0)
            }
        }
        .allowsHitTesting(false)
    }
    
    func showConfetti() {
        particles = (0..<80).map { _ in
            ConfettiParticle(
                color: Color(hue: .random(in: 0...1), saturation: .random(in: 0.7...0.9), brightness: .random(in: 0.8...1)),
                xOffset: .random(in: -30...30),
                yOffset: .random(in: -10...10),
                angle: .degrees(.random(in: 0...360)),
                scale: .random(in: 0.8...1.2)
            )
        }
        
        isAnimating = true
        
        // Animate particles falling down
        withAnimation(.easeOut(duration: 1.0)) {
            for index in particles.indices {
                particles[index].yOffset += CGFloat.random(in: 200...700)
                particles[index].xOffset += CGFloat.random(in: -250...250)
                particles[index].angle += .degrees(180)
            }
        }
        
        // Fade out
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = false
            }
        }
    }
}

#Preview {
    ConfettiView()
}
