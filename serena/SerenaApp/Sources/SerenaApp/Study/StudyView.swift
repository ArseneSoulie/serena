import SwiftUI

struct StudyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Radicals, Kanji & Vocab.")
                    .foregroundStyle(.secondary)
                    .font(.headline)
                CourseCardView(
                    title: "Lessons",
                    subtitle: "today",
                    mainColor: Color(hue: 320 / 360, saturation: 1, brightness: 1),
                    countLabel: "15",
                ) {}
                CourseCardView(
                    title: "Reviews",
                    mainColor: Color(hue: 200 / 360, saturation: 0.98, brightness: 1),
                    countLabel: "495",
                ) {}
                Divider()
                Spacer().frame(height: 20)
                Text("Extra studies")
                    .foregroundStyle(.secondary)
                    .font(.headline)

                HStack {
                    CourseCardView(
                        title: "Review",
                        mainColor: Color(hue: 23 / 360, saturation: 0.17, brightness: 0.38),
                    ) {}
                    CourseCardView(
                        title: "Lessons",
                        mainColor: Color(hue: 23 / 360, saturation: 0.17, brightness: 0.38),
                    ) {}
                }

                Divider()
                Spacer().frame(height: 20)
                Text("More")
                    .foregroundStyle(.secondary)
                    .font(.headline)
                CourseCardView(
                    title: "Kaniwani ↺",
                    subtitle: "english to japanese",
                    mainColor: Color(hue: 23 / 360, saturation: 0.91, brightness: 0.92),
                    countLabel: "2",
                ) {}
                CourseCardView(
                    title: "Kanas",
                    mainColor: Color(hue: 45 / 360, saturation: 0.92, brightness: 0.91),
                ) {}
            }
        }
        .padding()
    }
}

#Preview {
    StudyView()
}
