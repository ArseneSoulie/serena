import SwiftUI

struct ExerciceRedirectionBannerView: View {
    let image: ImageResource
    let label: LocalizedStringResource
    let onBannerTapped: () -> Void

    var body: some View {
        Button(action: onBannerTapped) {
            ZStack(alignment: .bottom) {
                Image(image)
                    .resizable()
                    .scaledToFit()

                HStack {
                    Spacer()
                    Text(label)
                        .typography(.headline)
                        .bold()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.white)
                .padding()
                .background {
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black.opacity(0.7), location: 0.2),
                            .init(color: .black.opacity(0.7), location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom,
                    )
                }
            }
            .cornerRadius(.default)
        }.buttonStyle(.plain)
            .frame(maxWidth: 600)
    }
}
