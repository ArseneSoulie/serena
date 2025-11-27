import SwiftUI

public struct LearnMainPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("I'm new, where do i begin ?")
                Text("The origin of the Japanese writing system")
                Text("How do i search for information in a dictionary ?")
                Text("How to learn japanese and remember things ?")
            } header: {
                Text("Getting started")
            }

            Section {
                Text("What are hiragana used for ?")
                Text("What are katakana used for ?")
                Text("How many alphabets are there ?")
            } header: {
                Text("The kanas - part 1")
            }

            Section {
                Text("How to draw kana ?")
                Text("How to write kana ?")
                Text("What are diacritics ? Dakuten, handakuten")
                Text("There are small ones now ?")
                Text("What are prolongations ?")
                Text("What are the new special katakana characters ?")
                Text("How do i recognize the right character ? か　and　カ look the same ;(")
            } header: {
                Text("The kanas - part 2")
            }

            Section {
                Text("What are kanji ? Why do we use them ?")
                Text("How do i pronounce japanese ?")
                Text("What's the difference between onyomi and kunyomi ?")
                Text("What's a mora ?")
                Text("What are furigana ?")
            } header: {
                Text("The japanese language - kanji")
            }

            Section {
                Text("What are romaji ?")
                Text("How do I write japanese on my keyboard ? And how do i become good at it ?")
            } header: {
                Text("The japanese language - keyboard")
            }

            Section {
                Text("What are particles ?")
                Text("I thought は was pronouced ha but its pronounced wa ?")
                Text("I thought を was pronouced wo but its pronounced o ?")
                Text("I thought へ was pronouced wo but its pronounced e ?")
                Text("What are okurigana ?")
                Text("Let's break down sentenses and read them")
            } header: {
                Text("The japanese language - grammar")
            }

            Section {
                Text("You're telling me there's cursive ?")
                Text("What are hentaigana ?")
                Text("Where're ye,yi,wi,wu,we gone ?")
                Text("うぉ is written UXO... really ?")
            } header: {
                Text("The japanese language - cursed edition")
            }
        }.navigationTitle(.learn)
    }
}

#Preview {
    NavigationView {
        LearnMainPage()
    }
}
