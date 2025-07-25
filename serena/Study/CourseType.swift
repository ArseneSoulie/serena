import SwiftUI

enum CourseType {
    case lesson
    case review
    
    var mainColor: Color {
        switch self {
        case .lesson: .pink
        case .review: .blue
        }
    }
}

struct CourseCardView: View {
    let title: String
    let subtitle: String
    let mainColor: Color
    let textColor: Color = .white
    let countLabel: String?
    let onSelect: () -> Void
    
    
    init(
        title: String,
        subtitle: String = "",
        mainColor: Color,
        countLabel: String? = nil,
        onSelect: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.mainColor = mainColor
        self.countLabel = countLabel
        self.onSelect = onSelect
    }
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.headline)
                    if let countLabel {
                        Text(countLabel)
                            .font(.callout)
                            .padding(.horizontal, 8)
                            .foregroundStyle(mainColor)
                            .background(textColor)
                            .clipShape(.capsule)
                    }
                }
                Text(subtitle)
                HStack{
                    Spacer()
                    Text("  Start →")
                        .padding(.horizontal, 6)
                        .overlay {
                            Capsule().stroke()
                        }
                }
            }
            .padding(.all)
            .foregroundStyle(textColor)
            .background(mainColor)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}
