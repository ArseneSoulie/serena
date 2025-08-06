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
            }
            .padding(.vertical, 2)
        }
    }
    
    func toggleLine() {
        withAnimation { isOn.toggle() }
    }
}
