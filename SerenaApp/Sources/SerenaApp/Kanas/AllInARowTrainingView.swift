//
//  AllInARowTrainingView.swift
//  SerenaApp
//
//  Created by A S on 05/08/2025.
//
import SwiftUI

struct AllInARowTrainingView: View {
    @Environment(\.trainingMode) var trainingMode
    let kanas: [String]
    var body: some View {
        Text("Hello, world!")
    }
}

#Preview {
    AllInARowTrainingView(kanas: [
        "a", "yo", "ka", "gya"
    ])
}
