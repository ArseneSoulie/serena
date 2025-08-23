import CoreLocation
import SwiftUI

public struct DrawingView<ContentView: View>: View {
    @State var currentPoints: [CGPoint] = []
    @State var currentPoint: CGPoint = .zero
    @State var currentPath: Path = .init()
    @State var lastLocation: CGPoint = .zero
    @Binding var finishedPaths: [Path]
    @State var redoStack: [Path] = []
    @State var isDrawing: Bool = false

    let minimumDistanceToNextPoint: CGFloat = 20

    let driedStrokeColor = Color(white: 0.2)
    let wetStrokeColor = Color.black
    let strokeStyle = StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)

    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    @ViewBuilder let contentView: () -> ContentView

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
                redoStack = []
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
                    .frame(width: isDrawing ? 30 : 0, height: isDrawing ? 30 : 0)
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
        drawingToolBar
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

    var drawingToolBar: some View {
        HStack(spacing: 24) {
            Button(
                action: {
                    let removedPath = finishedPaths.popLast()
                    if let removedPath {
                        redoStack.append(removedPath)
                    }
                },
                label: {
                    Image(systemName: "arrow.uturn.backward")
                        .resizable()
                        .frame(width: 24, height: 24)
                },
            )
            Button(
                action: {
                    let redoPath = redoStack.popLast()
                    if let redoPath {
                        finishedPaths.append(redoPath)
                    }
                },
                label: {
                    Image(systemName: "arrow.uturn.forward")
                        .resizable()
                        .frame(width: 24, height: 24)
                },
            )
            Button(
                action: {
                    redoStack = []
                    finishedPaths = []
                },
                label: {
                    Image(systemName: "eraser.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                },
            )
            Spacer()
        }
        .padding(24)
    }
}

extension CGPoint {
    func distance(_ other: CGPoint) -> CGFloat {
        sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}

#Preview {
    @Previewable @State var paths: [Path] = []
    DrawingView(
        finishedPaths: $paths,
        contentView: {
            Text("あ")
                .foregroundStyle(Color(white: 0.8))
                .aspectRatio(1, contentMode: .fit)
                .padding(48)
        },
    )
}
