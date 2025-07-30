import SwiftUI

public struct KanjiStrokesView : View {
    @State private var drawAmount: CGFloat = 0.0
    private let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    func drawKanji() {
        drawAmount = 0.0
        withAnimation(.easeIn(duration: 2)) {
            drawAmount = 1.0
        }
    }
    
    public var body: some View {
        let color: Color = .black
        if let url, let strokesView = KanjiStrokes(from: url) {
            VStack {
                strokesView
                    .stroke(color.opacity(0.2), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .overlay {
                        strokesView
                            .trim(from: 0, to: drawAmount)
                            .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    }
                    .frame(width: 100, height: 100)
                Slider(value: $drawAmount, in: 0...1)
                    .padding(.vertical)
                Button("Draw", action: drawKanji)
            }
            .onAppear(perform: drawKanji)
        } else {
            Image(systemName: "questionmark.square.dashed")
                .resizable()
                .frame(width: 100, height: 100)
            Text("No stroke data for this kanji")
                .font(.callout)
                .padding(.vertical)
        }
    }
}

#Preview {
    let url = Bundle.module.url(forResource: "05358", withExtension: "svg")
    KanjiStrokesView(url: url)
}
