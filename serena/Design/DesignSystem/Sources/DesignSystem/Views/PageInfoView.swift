import SwiftUI

public struct PageInfoView: View {
    let infoPages: [LocalizedStringResource]
    let image: ImageResource

    @State var selectedTabKey: String

    public init(infoPages: [LocalizedStringResource], image: ImageResource) {
        self.infoPages = infoPages
        self.image = image
        selectedTabKey = infoPages.first?.key ?? ""
    }

    private var selectedIndex: Int {
        infoPages.firstIndex(where: { $0.key == selectedTabKey }) ?? 0
    }

    private var showBackwardButton: Bool {
        selectedIndex > 0
    }

    private var showForwardButton: Bool {
        selectedIndex < infoPages.count - 1
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(image)
                .resizable()
                .frame(width: 64, height: 64)

            TabView(selection: $selectedTabKey) {
                ForEach(infoPages, id: \.key) { pageText in
                    VStack {
                        Text(pageText)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .tag(pageText.key)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(minHeight: 150)

            HStack {
                if showBackwardButton {
                    Button("", systemImage: "chevron.backward", action: {
                        withAnimation {
                            selectedTabKey = infoPages[selectedIndex - 1].key
                        }
                    })
                }

                Spacer()

                if showForwardButton {
                    Button("", systemImage: "chevron.forward", action: {
                        withAnimation {
                            selectedTabKey = infoPages[selectedIndex + 1].key
                        }
                    })
                }
            }
        }
        .padding()
        .frame(minWidth: 350)
        .presentationCompactAdaptation(.popover)
    }
}
