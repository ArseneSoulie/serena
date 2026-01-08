import SwiftUI

public struct ProgressBarView: View {
    @Binding var progress: Double
    @State var barColor: Color = .gray

    let barHeight: CGFloat = 20

    public init(progress: Binding<Double>) {
        _progress = progress
    }

    public var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: barHeight)
                    .foregroundColor(Color.gray.opacity(0.3))

                GeometryReader { geometry in
                    Rectangle()
                        .frame(width: geometry.size.width * progress, height: barHeight)
                        .foregroundStyle(barColor)
                }
            }
            .frame(height: barHeight)
            .clipShape(.capsule)
            ZStack {
                Text(progress, format: .percent.rounded(increment: 1))
                Text(100, format: .percent.rounded(increment: 1)).hidden()
            }
        }
        .onChange(of: progress) { oldValue, newValue in
            if oldValue < newValue {
                withAnimation(.snappy(duration: 0.2)) {
                    barColor = .green
                } completion: {
                    withAnimation {
                        barColor = .gray
                    }
                }
            } else {
                withAnimation(.snappy(duration: 0.2)) {
                    barColor = .red
                } completion: {
                    withAnimation {
                        barColor = .gray
                    }
                }
            }
        }
    }
}
