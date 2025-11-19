extension Set<KanaLine> {
    subscript(containsLine kanaLine: KanaLine) -> Bool {
        get { contains(kanaLine) }
        set {
            if newValue {
                insert(kanaLine)
            } else {
                remove(kanaLine)
            }
        }
    }

    subscript(containsLines kanaLines: [KanaLine]) -> Bool {
        get { isSuperset(of: kanaLines) }
        set {
            if newValue {
                self = union(kanaLines)
            } else {
                self = subtracting(kanaLines)
            }
        }
    }
}

extension Set<KanaLine> {
    var kanaCount: Int {
        reduce(0) { partialResult, line in
            partialResult + line.kanas.count(where: { $0 != nil })
        }
    }
}

extension [KanaLine] {
    var kanaCount: Int {
        reduce(0) { partialResult, line in
            partialResult + line.kanas.count(where: { $0 != nil })
        }
    }
}
