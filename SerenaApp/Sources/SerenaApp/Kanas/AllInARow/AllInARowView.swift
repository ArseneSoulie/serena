//
//  AllInARowTrainingView.swift
//  SerenaApp
//
//  Created by A S on 05/08/2025.
//
import SwiftUI

struct AllInARowView: View {
    let kanas: [String]
    let kanaType: KanaType
    
    
    @State var textColor: Color = .primary
    
    @State private var shakeTrigger: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Text("う")
                .foregroundStyle(textColor)
                .font(.largeTitle)
                .modifier(ShakeEffect(animatableData: shakeTrigger))
            
            Button("Shake!") {
                withAnimation(.default) {
                    textColor = .red
                    shakeTrigger += 1
                } completion: {
                    withAnimation {
                        textColor = .primary
                    }
                }
            }
        }
        .padding()
    }
    
}

#Preview {
    AllInARowView(kanas: [
        "a", "yo", "ka", "gya"
    ], kanaType: .hiragana)
}


import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var rotation: Angle = .degrees(2)
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let shake = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        let angle = CGFloat(rotation.radians) * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        
        var transform = CGAffineTransform.identity
        
        transform = transform.translatedBy(x: size.width / 2, y: size.height / 2)
        
        transform = transform.rotated(by: angle)
        transform = transform.translatedBy(x: shake, y: 0)
        
        transform = transform.translatedBy(x: -size.width / 2, y: -size.height / 2)
        
        return ProjectionTransform(transform)
    }
}
