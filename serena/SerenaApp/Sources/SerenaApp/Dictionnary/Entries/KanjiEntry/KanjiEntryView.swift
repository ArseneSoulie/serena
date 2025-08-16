//
//  KanjiEntryView.swift
//  serena
//
//  Created by A S on 24/07/2025.
//

import KanjiVGParser
import SwiftUI

struct KanjiEntry {
    let kanji: String
    let meanings: Meanings
    let onyomiReadings: [String]
    let kunyomiReadings: [String]
    let nanoriReadings: [String]
    var meaningMnemonics: Mnemonics
    var readingMnemonics: Mnemonics
    let compounds: [WordCompound]
    let info: KanjiInfo
    let radicals: [String]
    let similarKanji: [String]

    let waniKaniInfo: WaniKaniInfo?
    let svgId: String?
}

struct WaniKaniInfo {
    var currentProgress: WanikaniProgress
}

struct KanjiInfo {
    let gradeLevel: Int
    let jlptLevel: JLPTLevel?
    let frequency: Int
    let strokeCount: Int
    let wanikaniLevel: Int?
}

struct KanjiEntryView: View {
    @State var entry: KanjiEntry
    @State var showsSettings = false
    @State var showFurigana = false
    @State var useKatakanaForOnyomi = true
    @State var showStrokeOrder = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        KanjiItemView(kanji: entry.kanji, wanikaniProgression: entry.waniKaniInfo?.currentProgress) {}
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
                    MnemonicsView(title: "Meaning mnemonics", mnemonics: $entry.meaningMnemonics)
                    MnemonicsView(title: "Reading mnemonics", mnemonics: $entry.readingMnemonics)
                    Divider()
                    WordCompoundListView(title: "Compounds", compounds: entry.compounds)
                        .environment(\.showFurigana, showFurigana)
                        .environment(\.useKatakanaForOnyomi, useKatakanaForOnyomi)
                    Divider()
                }.padding()
            }
            .environment(\.disableTiles, showStrokeOrder || showsSettings)
            .toolbar {
                if let svgId = entry.svgId {
                    KanjiStrokesToolbar(showStrokeOrder: $showStrokeOrder, svgId: svgId)
                }
                KanjiEntryOptionsToolbar(
                    showFurigana: $showFurigana,
                    useKatakanaForOnyomi: $useKatakanaForOnyomi,
                    showsSettings: $showsSettings
                )
            }
            .animation(.easeOut, value: showsSettings)
            .animation(.easeOut, value: showFurigana)
            .animation(.easeOut, value: useKatakanaForOnyomi)
            .animation(.easeOut, value: showStrokeOrder)
        }
    }
}

enum WanikaniProgress: Int, CaseIterable {
    case notStarted
    case apprentice1
    case apprentice2
    case apprentice3
    case apprentice4
    case guru1
    case guru2
    case master
    case enlightened
    case burned

    var currentLevel: WanikaniProgressCategory {
        switch self {
        case .notStarted: .notStarted
        case .apprentice1, .apprentice2, .apprentice3, .apprentice4: .apprentice
        case .guru1, .guru2: .guru
        case .master: .master
        case .enlightened: .enlightened
        case .burned: .burned
        }
    }
}

enum WanikaniProgressCategory {
    case notStarted
    case apprentice
    case guru
    case master
    case enlightened
    case burned

    var nextCategory: WanikaniProgressCategory? {
        switch self {
        case .notStarted: .apprentice
        case .apprentice: .guru
        case .guru: .master
        case .master: .enlightened
        case .enlightened: .burned
        case .burned: nil
        }
    }

    var color: Color {
        switch self {
        case .notStarted: .gray.mix(with: .white, by: 0.6)
        case .apprentice: .pink
        case .guru: .purple
        case .master: .blue
        case .enlightened: .cyan
        case .burned: .green
        }
    }
}

struct KanjiItemView: View {
    let kanji: String
    let wanikaniProgression: WanikaniProgress?

    let onTileTapped: () -> Void

    var body: some View {
        VStack {
            Button(kanji, action: onTileTapped)
                .buttonStyle(TileButtonStyle(tileSize: .largeEntry, tileKind: .kanji))

            if let wanikaniProgression {
                WanikaniProgressView(wanikaniProgression: wanikaniProgression)
            }
        }.fixedSize()
    }
}

struct WanikaniProgressView: View {
    let wanikaniProgression: WanikaniProgress

    let allProgress = WanikaniProgress.allCases

    var body: some View {
        let progressBarSteps = WanikaniProgress
            .allCases
            .filter { $0.currentLevel == wanikaniProgression.currentLevel }

        HStack(spacing: 2) {
            ForEach(progressBarSteps, id: \.self) { progress in
                Rectangle().foregroundStyle(
                    progress.currentLevel
                        .color
                        .opacity(progress.rawValue <= wanikaniProgression.rawValue ? 1 : 0.3)
                        .gradient
                )
            }
            if
                let nextCategory = wanikaniProgression.currentLevel.nextCategory,
                wanikaniProgression.currentLevel != .notStarted {
                nextCategory.color.opacity(0.3)
            }
        }
        .frame(height: 4)
        .clipShape(.capsule)
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
            VStack(alignment: .leading) {
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
    let svgId: String

    var body: some View {
        Button(
            action: {
                showStrokeOrder.toggle()
            },
            label: {
                Image(systemName: "pencil.and.scribble")
            }
        ).popover(isPresented: $showStrokeOrder) {
            KanjiStrokesView(svgId: svgId)
                .padding(.all)
                .padding(.horizontal)
                .presentationCompactAdaptation(.popover)
        }
    }
}

extension KanjiStrokesView {
    init(svgId: String) {
        let url = Bundle.module.url(forResource: svgId, withExtension: "svg")
        self.init(url: url)
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
        meanings: .init(jishoMeanings: ["Simple"], userProvidedMeanings: []),
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
            .init(
                kind: .onyomi,
                word: "単位",
                reading: "タンイ",
                meanings: [
                    "unit",
                    "denomination",
                    "credit (in school)",
                    "n units of (e.g. \"in thousands\")",
                    "in amounts of",
                ]
            ),
            .init(
                kind: .kunyomi,
                word: "一重",
                reading: "ひとえ",
                meanings: ["one layer", "single layer", "monopetalous", "unlined kimono"]
            ),
            .init(
                kind: .kunyomi,
                word: "単衣",
                reading: "たんい",
                meanings: ["unlined kimono", "one kimono", "a single kimono"]
            ),
        ],
        info: .init(
            gradeLevel: 4,
            jlptLevel: .N3,
            frequency: 586,
            strokeCount: 9,
            wanikaniLevel: 3,
        ),
        radicals: ["十"],
        similarKanji: ["早", "果", "菓", "巣", "呆"],
        waniKaniInfo: .init(currentProgress: .apprentice3),
        svgId: "05358"
    )

    KanjiEntryView(entry: previewEntry)
}
