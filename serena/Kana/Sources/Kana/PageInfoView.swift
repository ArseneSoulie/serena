import SwiftUI

struct PageInfoView: View {
    let infoPages: [LocalizedStringResource]
    let image: ImageResource

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(image)
                .resizable()
                .frame(width: 64, height: 64)
            TabView {
                ForEach(infoPages, id: \.key) { pageText in
                    Text(pageText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(minHeight: 150)
        }
        .padding()
        .frame(minWidth: 300)
        .presentationCompactAdaptation(.popover)
    }
}
