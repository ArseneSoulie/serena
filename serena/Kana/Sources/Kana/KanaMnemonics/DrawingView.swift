import CoreLocation
import SwiftUI

public struct DrawingView<ContentView: View>: View {
    @State var currentPoints: [CGPoint] = []
    @State var currentPoint: CGPoint = .zero
    @State var currentPath: Path = .init()
    @State var lastLocation: CGPoint = .zero
    @State var finishedPaths: [Path] = []
    @State var isDrawing: Bool = false

    let minimumDistanceToNextPoint: CGFloat = 5

    let driedStrokeColor = Color(white: 0.2)
    let wetStrokeColor = Color.black
    let strokeStyle = StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round)

    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    @ViewBuilder let contentView: () -> ContentView
    let onSave: (Path) -> Void

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .onChanged {
                if !isDrawing {
                    currentPath = Path()
                    currentPath.move(to: $0.startLocation)
                    currentPoints = []
                }
                isDrawing = true

                let nextLocation = $0.location
                currentPoint = nextLocation
                if nextLocation.distance(lastLocation) > minimumDistanceToNextPoint {
                    addPointToCurrent(location: nextLocation)
                }
            }
            .onEnded { _ in
                isDrawing = false
                finishedPaths.append(currentPath)
                currentPath = Path()
                lastLocation = .zero
            }
    }

    var wetPath: Path {
        guard let firstPoint = currentPoints.first else { return Path() }
        return Path { path in
            path.move(to: firstPoint)
            for point in currentPoints {
                path.addLine(to: point)
            }
        }
    }

    var driedPath: Path {
        guard !finishedPaths.isEmpty else { return Path() }
        return Path { path in
            for finishedPath in finishedPaths {
                path.addPath(finishedPath)
            }
        }
    }

    public var body: some View {
        contentView()
            .overlay {
                driedPath.stroke(driedStrokeColor, style: strokeStyle)
                currentPath.stroke(driedStrokeColor, style: strokeStyle)
                wetPath.stroke(wetStrokeColor, style: strokeStyle).opacity(isDrawing ? 1 : 0)

                Circle()
                    .fill(wetStrokeColor)
                    .frame(width: isDrawing ? 25 : 0, height: isDrawing ? 25 : 0)
                    .position(currentPoint)
                    .animation(.default, value: isDrawing)
            }
            .allowsHitTesting(false)
            .background {
                Color(white: 0.9)
                    .gesture(dragGesture)
                    .allowsHitTesting(true)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(24)
            .onReceive(timer) { _ in updateWetness() }

        HStack {
            Button("Go back", systemImage: "arrowshape.turn.up.backward") {
                _ = finishedPaths.popLast()
            }

            Button("Clean", systemImage: "eraser.fill") {
                finishedPaths = []
            }

            Button("Save", systemImage: "square.and.arrow.down.fill") {
                onSave(driedPath)
            }
        }
    }

    func addPointToCurrent(location: CGPoint) {
        lastLocation = location
        currentPoints.append(location)
        currentPath.addLine(to: location)
    }

    func updateWetness() {
        if !currentPoints.isEmpty {
            _ = currentPoints.removeFirst()
        }
    }
}

extension CGPoint {
    func distance(_ other: CGPoint) -> CGFloat {
        sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}

#Preview {
    let url = Bundle.module.url(forResource: "カ", withExtension: "svg")

    DrawingView(
        contentView: {
            Text("あ")
                .foregroundStyle(Color(white: 0.8))
                .aspectRatio(1, contentMode: .fit)
                .padding(48)
        },
        onSave: { _ in },
    )
}
