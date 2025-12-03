import DesignSystem
import Navigation
import SwiftUI

public struct LearnMainPage: View {
    @Environment(NavigationCoordinator.self) var coordinator
    public init() {}

    public var body: some View {
        List {
            Button("Starting") {
                coordinator.push(.learn(.starting))
            }
            Button("Reading & Speaking") {
                coordinator.push(.learn(.readingSpeaking))
            }
            Button("Common Confusions") {
                coordinator.push(.learn(.commonConfusions))
            }
            Button("Grammar & Particles") {
                coordinator.push(.learn(.grammar))
            }
            Button("Into the World of Kanji") {
                coordinator.push(.learn(.kanji))
            }
            Button("Digital Japanese") {
                coordinator.push(.learn(.digital))
            }
            Button("The Rabbit Hole") {
                coordinator.push(.learn(.rabbitHole))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(.learn)
    }
}

#Preview {
    NavigationView {
        LearnMainPage()
    }
}
