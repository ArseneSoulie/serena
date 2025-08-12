import FoundationModels

public enum Destination: Hashable, Equatable {
    case levelUps([Kana])
    case allInARow([Kana])
    case exerciseSelection([Kana])
}
