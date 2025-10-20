import Foundation

func generateRandomString() -> String {
    let characters = "あいうえおかきくけこさしすせそ"
    let randomLength = Int.random(in: 1 ... 4)
    return String((0 ..< randomLength).compactMap { _ in characters.randomElement() })
}
