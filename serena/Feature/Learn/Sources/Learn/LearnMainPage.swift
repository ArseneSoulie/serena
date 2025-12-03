import DesignSystem
import SwiftUI

public struct LearnMainPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("I'm new, where do I start?")
                Text("Wait, there are multiple alphabets?")
                Text("What are Hiragana?")
                Text("What are Katakana?")
                Text("Where did this writing system come from?")
                Text("How can I learn Japanese?")
            } header: {
                Text("Starting")
            }

            Section {
                Text("What are the two little dashes ゛? (Dakuten)")
                Text("What are the little circles ゜? (Handakuten)")
                Text("What is a 'Mora' (Rhythm)?")
                Text("Why is this character so small? (っ, ゃ, ゅ, ょ)")
                Text("How do I make long sounds? (Prolongations)")
            } header: {
                Text("Reading & Speaking")
            }

            Section {
                Text("Why do kana look different depening on the font? ")
                    + Text("(き/")
                    + Text("き").inlineTypography(.title2, fontFamily: .yujiMai)
                    + Text(") (ら/")
                    + Text("ら").inlineTypography(.title2, fontFamily: .yujiMai)
                    + Text(")")
                Text("Help! 'SHI' (シ) and 'TSU' (ツ) look the same!")
                Text("Help! 'Ka' (か) and 'KA' (カ) look the same!")
                Text("Is it an 'R' or an 'L'?")
                Text("Why does 'Desu' sound like 'Dess'? (Devoicing)")
                Text("What are the new special katakana characters ?")
            } header: {
                Text("Common Confusions")
            }

            Section {
                Text("What are Particles?")
                Text("Why is は pronounced 'Wa'?")
                Text("Why is を pronounced 'O'?")
                Text("Why is へ pronounced 'E'?")
                Text("Let's break down a sentence")
            } header: {
                Text("Grammar & Particles")
            }

            Section {
                Text("What are Kanji and why do we need them?")
                Text("Onyomi? Kunyomi? What's the difference?")
                Text("What are Furigana? (The tiny kana above Kanji)")
                Text("What are Okurigana? (The kana attached to Kanji)")
                Text("How to write Japanese characters? (Stroke order)")
            } header: {
                Text("Into the World of Kanji")
            }

            Section {
                Text("What is 'Romaji'?")
                Text("How do I look things up in a dictionary?")
                Text("How do I type Japanese on my phone?")
                Text("How do I type on a computer?")
            } header: {
                Text("Digital Japanese")
            }

            Section {
                Text("Did you say cursive?")
                Text("What are Hentaigana?")
                Text("Where did We and Wi go?")
                Text("Why is 'Vertical Writing' a thing?")
                Text("The 'Cursed' Inputs (Typing UXO for ウォ)")
            } header: {
                Text("The Rabbit Hole")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(.learn)
    }
}

#Preview {
    NavigationView {
        LearnMainPage()
    }
}
