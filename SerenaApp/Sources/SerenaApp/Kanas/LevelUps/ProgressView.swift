import SwiftUI

struct ProgressView: View {
    @Binding var progress: Double
    @State var barColor: Color = .gray
    
    let barHeight: CGFloat = 30
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: barHeight)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                GeometryReader { geometry in
                    Capsule()
                        .frame(width: geometry.size.width * progress, height: barHeight)
                        .foregroundStyle(barColor)
                        .cornerRadius(10)
                }
            }
            .frame(height: barHeight)
            Text(progress.formatted(.percent.rounded(increment: 1)))
        }
        .onChange(of: progress, { oldValue, newValue in
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
        })
        .padding()
    }
}
