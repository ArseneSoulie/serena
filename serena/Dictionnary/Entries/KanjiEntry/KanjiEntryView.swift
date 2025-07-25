//
//  KanjiDictionnaryEntryView.swift
//  serena
//
//  Created by A S on 24/07/2025.
//

import SwiftUI

struct KanjiEntry {
    let kanji: String
    let meanings: Meanings
    let onyomiReadings: [String]
    let kunyomiReadings: [String]
    let nanoriReadings: [String]
    let meaningMnemonics: Mnemonics
    let readingMnemonics: Mnemonics
    let compounds: [WordCompound]
    let info: KanjiInfo
    let radicals: [String]
    let similarKanji: [String]
}

struct KanjiInfo {
    let gradeLevel: Int
    let jlptLevel: JLPTLevel?
    let frequency: Int
    let strokeCount: Int
    let wanikaniLevel: Int?
}



struct KanjiEntryView: View {
    let entry: KanjiEntry
    @State var showsSettings = false
    @State var showFurigana = false
    @State var useKatakanaForOnyomi = true
    @State var showStrokeOrder = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        KanjiItemView(kanji: entry.kanji, wanikaniProgression: .apprentice) {
                            
                        }
                        Spacer()
                        KanjiInfoView(info: entry.info)
                    }
                    Divider()
                    KanjiMeaningsView(title: "Meaning:", meanings: entry.meanings)
                    KanjiReadingsView(title: "ON readings:", readings: entry.onyomiReadings)
                        .environment(\.useKatakanaForOnyomi, useKatakanaForOnyomi)
                    KanjiReadingsView(title: "Kun readings:", readings: entry.kunyomiReadings)
                    KanjiReadingsView(title: "Nanori readings:", readings: entry.nanoriReadings)
                    
                    Divider()
                    KanjiRadicalsView(title: "Radicals", radicals: entry.radicals)
                    KanjiSimilarView(title: "Similar kanji:", similarKanji: entry.similarKanji)
                    Divider()
                    MnemonicsView(title: "Meaning mnemonics", mnemonics: entry.meaningMnemonics)
                    MnemonicsView(title: "Reading mnemonics", mnemonics: entry.readingMnemonics)
                    Divider()
                    WordCompoundListView(title: "Compounds", compounds: entry.compounds)
                        .environment(\.showFurigana, showFurigana)
                        .environment(\.useKatakanaForOnyomi, useKatakanaForOnyomi)
                    Divider()
                }.padding()
            }
            .toolbar {
                KanjiStrokesToolbar(showStrokeOrder: $showStrokeOrder)
                KanjiEntryOptionsToolbar(
                    showFurigana: $showFurigana,
                    useKatakanaForOnyomi: $useKatakanaForOnyomi,
                    showsSettings: $showsSettings
                )
            }
            
        }
    }
}

enum WanikaniProgression {
    case apprentice
    case guru
    case master
    case enlightened
    case burned
}

struct KanjiItemView: View {
    let kanji: String
    let wanikaniProgression: WanikaniProgression?
    
    let onTileTapped: () -> Void
    
    var body: some View {
        Button(kanji, action: onTileTapped)
            .buttonStyle(TileButtonStyle(tileSize: .largeEntry, tileKind: .kanji))
    }
}


struct KanjiEntryOptionsToolbar: View {
    @Binding var showFurigana: Bool
    @Binding var useKatakanaForOnyomi: Bool
    @Binding var showsSettings: Bool
    
    var body: some View {
        Button("Settings", systemImage: "slider.vertical.3") {
            showsSettings.toggle()
        }.popover(isPresented: $showsSettings) {
            VStack {
                Toggle("Show furigana", isOn: $showFurigana)
                Toggle("Use katakana for onyomi", isOn: $useKatakanaForOnyomi)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .presentationCompactAdaptation(.popover)
        }
    }
}

struct KanjiStrokesToolbar: View {
    @Binding var showStrokeOrder: Bool
    
    var body: some View {
        Button(
            action: { showStrokeOrder.toggle() },
            label: { Image(.customPaintbrushPointedFillBadgeQuestionmark)}
        ).popover(isPresented: $showStrokeOrder) {
            Text("yo")
                .presentationCompactAdaptation(.popover)
        }
    }
}

struct KanjiInfoView: View {
    let info: KanjiInfo
    
    var body: some View {
        VStack(alignment: .trailing) {
            if let wanikaniLevel = info.wanikaniLevel {
                HStack {
                    Text("WaniKani Level")
                    Text("\(wanikaniLevel)")
                }
            }
            HStack {
                Text("Grade")
                Text("\(info.gradeLevel)")
            }
            HStack {
                Text("JLPT")
                Text("\(info.jlptLevel?.rawValue ?? "-")")
            }
            HStack {
                Text("Frequency")
                Text("\(info.frequency)")
            }
        }
    }
}


#Preview {
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
        similarKanji: ["早","果","菓","巣","呆"]
    )
    
    KanjiEntryView(entry: previewEntry)
}


