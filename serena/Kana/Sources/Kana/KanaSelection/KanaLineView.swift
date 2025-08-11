import SwiftUI

struct KanaLineView: View {
    @Environment(\.kanaDisplayType) var kanaDisplayType
    
    let kanaLine: KanaLine
    
    @Binding var isOn: Bool
    
    var body: some View {
        GridRow {
            Button(
                action: toggleLine,
                label: { Text(kanaLine.id).padding(8) }
            )
            .tint(.primary)
            .gridColumnAlignment(.trailing)
            
            Button(action: toggleLine) {
                HStack(spacing: 4) {
                    ForEach(kanaLine.kanas, id: \.kanaId) { kana in
                        let displayedText = (kana ?? "a").format(kanaDisplayType)
                        
                        Text(displayedText)
                            .font(.title2)
                            .padding(.all, 6)
                            .frame(maxWidth: .infinity)
                            .background { Color(white: 0.97) }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .opacity(kana == nil ? 0 : 1)
                    }
                }
                .padding(.all, 4)
                .foregroundStyle (isOn ? Color(white: 0.2) : Color(white: 0.4))
                .background { isOn ? .mint : Color(white: 0.92) }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .topTrailing) {
                    if isOn {
                        ZStack {
                            Color.white
                                .frame(width: 24, height: 24)
                                .clipShape(.circle)
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.green)
                        }
                        .offset(x: 8, y: -8)
                    }
                }
            }
            
            Text(kanaLine.id).hidden()
        }
    }
    
    func toggleLine() {
        withAnimation { isOn.toggle() }
    }
}

#Preview {
    @Previewable @State var isOn = true
    Grid {
        KanaLineView(
            kanaLine: .init(name: "r-", kanas: ["ra","ri","ru","re","ro"]),
            isOn: $isOn
        )
        KanaLineView(
            kanaLine: .init(name: "r-", kanas: ["ra","ri","ru","re","ro"]),
            isOn: $isOn
        )
    }
}
