//
//  DictionnaryView.swift
//  SerenaApp
//
//  Created by A S on 30/07/2025.
//

import SwiftUI

struct DictionnaryView: View {
    let previewEntry: KanjiEntry = .init(
        kanji: "単",
        meanings: .init(jishoMeanings: ["Simple"], userProvidedMeanings: []) ,
        onyomiReadings: ["タン"],
        kunyomiReadings: ["ひとえ"],
        nanoriReadings: [],
        meaningMnemonics: .init(
            wkMnemonic: .init(
                explanation: "The simple radical and the simple kanji are the same!",
                hint: "Simple is simple!"
            )
        ),
        readingMnemonics: .init(
            wkMnemonic: .init(
                explanation: "One of the most simple things in the world is getting a tan (たん). All you have to do is stand outside long enough. It doesn't matter what skin type you have or what the weather is like. Eventually, if you stand out there long enough, you'll get a tan.",
                hint: "Get a tan, it's simple, stupid! (Though it's terrible for you so uh... don't always take our advice, kay?)",
            )
        ),
        compounds: [
            .init(kind: .onyomi, word: "単", reading: "タン", meanings: ["single", "simple"]),
            .init(kind: .onyomi, word: "単位", reading: "タンイ", meanings: ["unit", "denomination","credit (in school)", "n units of (e.g. \"in thousands\")", "in amounts of"]),
            .init(kind: .kunyomi, word: "一重", reading: "ひとえ", meanings: ["one layer", "single layer", "monopetalous", "unlined kimono"]),
            .init(kind: .kunyomi, word: "単衣", reading: "たんい", meanings: ["unlined kimono", "one kimono", "a single kimono"]),
        ],
        info: .init(
            gradeLevel: 4,
            jlptLevel: .N3,
            frequency: 586,
            strokeCount: 9,
            wanikaniLevel: 3,
        ),
        radicals: ["十"],
        similarKanji: ["早","果","菓","巣","呆"],
        waniKaniInfo: .init(currentProgress: .apprentice3),
        svgId: "05358"
    )
    
    var body: some View {
        KanjiEntryView(entry: previewEntry)
    }
}
