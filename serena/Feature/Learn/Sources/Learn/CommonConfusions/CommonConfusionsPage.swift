import DesignSystem
import SwiftUI

public struct CommonConfusionsPage: View {
    public init() {}

    public var body: some View {
        List {
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
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Common Confusions")
    }
}

#Preview {
    NavigationView {
        CommonConfusionsPage()
    }
}
