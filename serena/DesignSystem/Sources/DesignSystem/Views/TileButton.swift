import SwiftUI

public enum TileSize {
    case small
    case medium
    case largeEntry

    var font: Typography {
        switch self {
        case .small: .body
        case .medium: .title2
        case .largeEntry: .largeTitle
        }
    }

    var paddings: CGFloat {
        switch self {
        case .small: 2
        case .medium: 8
        case .largeEntry: 8
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: 2
        case .medium: 4
        case .largeEntry: 4
        }
    }

    var pressOffset: CGFloat {
        switch self {
        case .small: 2
        case .medium: 4
        case .largeEntry: 5
        }
    }
}

public enum TileKind {
    case radical
    case kanji
    case vocabulary
    case kana
    case custom(Color)

    var color: Color {
        switch self {
        case .radical: .blue
        case .kanji: .pink
        case .vocabulary: .purple
        case .kana: .cyan
        case let .custom(color): color
        }
    }
}

public struct TileButtonStyle: ButtonStyle {
    @Environment(\.disableTiles) var isTileDisabled
    let tileSize: TileSize
    let tileKind: TileKind

    public init(tileSize: TileSize = .small, tileKind: TileKind) {
        self.tileSize = tileSize
        self.tileKind = tileKind
    }

    public func makeBody(configuration: Configuration) -> some View {
        let tileColor = isTileDisabled ? Color.gray : tileKind.color

        configuration.label
            .typography(tileSize.font)
            .foregroundStyle(.white)
            .padding(.all, tileSize.paddings)
            .background {
                RoundedRectangle(cornerRadius: tileSize.cornerRadius)
                    .fill(tileColor.gradient)
            }
            .offset(x: 0, y: configuration.isPressed ? tileSize.pressOffset : 0)
            .background {
                tileColor.brightness(-0.2)
                    .clipShape(RoundedRectangle(cornerRadius: tileSize.cornerRadius))
                    .offset(x: 0, y: tileSize.pressOffset)
            }
    }
}
