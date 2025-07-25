import SwiftUI

enum TileSize {
    case small
    case largeEntry
    
    var font: Font {
        switch self {
        case .small: .body
        case .largeEntry: .largeTitle
        }
    }
    
    var isBold: Bool {
        switch self {
        case .small: false
        case .largeEntry: false
        }
    }
    
    var paddings: CGFloat {
        switch self {
        case .small: 2
        case .largeEntry: 8
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small: 2
        case .largeEntry: 4
        }
    }
    
    var pressOffset: CGFloat {
        switch self {
        case .small: 2
        case .largeEntry: 5
        }
    }
}

enum TileKind {
    case radical
    case kanji
    case vocabulary
    
    var color: Color {
        switch self {
        case .radical: .blue
        case .kanji: .pink
        case .vocabulary: .purple
        }
    }
}

struct TileButtonStyle: ButtonStyle {
    @Environment(\.disableTiles) var isTileDisabled
    let tileSize: TileSize
    let tileKind: TileKind
    
    init(tileSize: TileSize = .small, tileKind: TileKind) {
        self.tileSize = tileSize
        self.tileKind = tileKind
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let tileColor = isTileDisabled ? Color.gray : tileKind.color
        
        configuration.label
            .bold(tileSize.isBold)
            .font(tileSize.font)
            .foregroundStyle(.white)
            .padding(.all, tileSize.paddings)
            .background {
                RoundedRectangle(cornerRadius: tileSize.cornerRadius)
                    .fill(tileColor.mix(with: .black, by: configuration.isPressed ? 0.1 : 0).gradient)
            }
            .offset(x: 0, y: configuration.isPressed ? tileSize.pressOffset : 0)
            .background {
                tileColor.mix(with: .black, by: 0.2)
                    .clipShape(RoundedRectangle(cornerRadius: tileSize.cornerRadius))
                    .offset(x: 0, y: tileSize.pressOffset)
            }
    }
}
