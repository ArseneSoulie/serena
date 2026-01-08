import DesignSystem
import Navigation
import SwiftUI

public struct LearnMainPage: View {
    @Environment(NavigationCoordinator.self) var coordinator
    public init() {}

    public var body: some View {
        ScrollView {
            VStack {
                LearnCategoryView(
                    title: "Starting",
                    subtitle: "Let's begin!",
                    illustration: Image(._TrainingBanner.allInARow),
                    totalProgressionSteps: 5,
                    currentProgress: 4,
                    onTap: { coordinator.push(.learn(.starting)) },
                )

                LearnCategoryView(
                    title: "Reading & Speaking",
                    subtitle: "【こんにちは】 Hey you're reading!",
                    illustration: Image(._TrainingBanner.allInARow),
                    totalProgressionSteps: 5,
                    currentProgress: 4,
                    onTap: { coordinator.push(.learn(.readingSpeaking)) },
                )

                LearnCategoryView(
                    title: "Common Confusions",
                    subtitle: "Having issue with シ and ツ?\nDon't worry I got you!",
                    illustration: Image(._TrainingBanner.allInARow),
                    totalProgressionSteps: 5,
                    currentProgress: 4,
                    onTap: { coordinator.push(.learn(.commonConfusions)) },
                )

                LearnCategoryView(
                    title: "Grammar & Particles",
                    subtitle: "Why is は sometimes pronoucied wa ?\nThat's a particle for you!",
                    illustration: Image(._TrainingBanner.allInARow),
                    totalProgressionSteps: 5,
                    currentProgress: 4,
                    onTap: { coordinator.push(.learn(.grammar)) },
                )

                LearnCategoryView(
                    title: "Into the World of Kanji",
                    subtitle: "2000 characters to read a journal?\nA piece of cake!",
                    illustration: Image(._TrainingBanner.allInARow),
                    totalProgressionSteps: 5,
                    currentProgress: 4,
                    onTap: { coordinator.push(.learn(.kanji)) },
                )

                LearnCategoryView(
                    title: "Digital Japanese",
                    subtitle: "Want to type ? Get set... go!",
                    illustration: Image(._TrainingBanner.allInARow),
                    totalProgressionSteps: 5,
                    currentProgress: 4,
                    onTap: { coordinator.push(.learn(.digital)) },
                )

                LearnCategoryView(
                    title: "The Rabbit Hole",
                    subtitle: "Looking in the strange, the esoteric and the fun parts of Japanese",
                    illustration: Image(._TrainingBanner.allInARow),
                    totalProgressionSteps: 5,
                    currentProgress: 4,
                    onTap: { coordinator.push(.learn(.rabbitHole)) },
                )
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(.learn)
    }
}

struct LearnCategoryView: View {
    let title: String
    let subtitle: String
    let illustration: Image
    let totalProgressionSteps: Int
    let currentProgress: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                Image(._TrainingBanner.levelUp)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                ZStack {
                    Color.clear
                        .background(.ultraThinMaterial)
                        .colorMultiply(Color(white: 0.4))
                        .opacity(0.95)

                    HStack {
                        VStack(alignment: .leading) {
                            Text(title).typography(.title2).bold()
                            Text(subtitle).typography(.caption)
                        }
                        Spacer()

                        Image(systemName: "chevron.right")
                    }
                    .padding(.vertical, 8)
                    .padding(.bottom, 4)
                    .padding(.horizontal)
                }.fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.leading)
            .cornerRadius(.default)
            .overlay(alignment: .topTrailing) {
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("\(currentProgress)/\(totalProgressionSteps)")
                        .bold()
                }
                .padding()
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    NavigationView {
        LearnMainPage()
    }.environment(NavigationCoordinator())
}
