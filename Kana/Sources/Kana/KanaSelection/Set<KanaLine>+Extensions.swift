extension Set<KanaLine> {
    subscript(containsLine kanaLine: KanaLine) -> Bool {
        get { self.contains(kanaLine) }
        set {
            if newValue {
                self.insert(kanaLine)
            } else {
                self.remove(kanaLine)
            }
        }
    }
    
    subscript(containsLines kanaLines: [KanaLine]) -> Bool {
        get { self.isSuperset(of: kanaLines)}
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
        self.reduce(0) { partialResult, line in
            partialResult + line.kanas.count(where: { $0 != nil} )
        }
    }
}

extension Array<KanaLine> {
    var kanaCount: Int {
        self.reduce(0) { partialResult, line in
            partialResult + line.kanas.count(where: { $0 != nil} )
        }
    }
}
