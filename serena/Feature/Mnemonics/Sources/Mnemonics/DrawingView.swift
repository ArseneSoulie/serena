import CoreLocation
import SwiftUI

public struct DrawingView<ContentView: View>: View {
    @State var currentPoints: [CGPoint] = []
    @State var currentLocation: CGPoint = .zero
    @State var lastLocation: CGPoint = .zero
    @State var currentPath: Path = .init()
    @Binding var finishedPaths: [Path]
    @State var redoStack: [Path] = []
    @State var isDrawing: Bool = false

    let minimumDistanceToNextPoint: CGFloat = 5

    let driedStrokeColor = Color(white: 0.2)
    let wetStrokeColor = Color.black
    let strokeStyle = StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)

    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    @ViewBuilder let contentView: () -> ContentView

    @State private var drawingBounds: CGSize?

    private func dragGesture(bounds: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged {
                let nextPoint = normalizePoint($0.location, bounds: bounds)
                if !CGRect(x: 0, y: 0, width: 1, height: 1).contains(nextPoint) {
                    onEndPath()
                    return
                }

                if !isDrawing {
                    currentPath = Path()
                    currentPath.move(to: nextPoint)
                    currentPoints = []
                }
                withAnimation {
                    isDrawing = true
                }

                currentLocation = $0.location
                if currentLocation.distance(lastLocation) > minimumDistanceToNextPoint {
                    lastLocation = currentLocation
                    addPointToCurrent(point: nextPoint)
                }
            }
            .onEnded { _ in
                onEndPath()
            }
    }

    func onEndPath() {
        withAnimation {
            isDrawing = false
        }
        if currentPath.isEmpty { return }
        finishedPaths.append(currentPath)
        redoStack = []
        currentPath = Path()
    }

    func normalizePoint(_ point: CGPoint, bounds: CGSize) -> CGPoint {
        CGPoint(x: point.x / bounds.width, y: point.y / bounds.height)
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
        VStack(spacing: 16) {
            Text(.draw)
            contentView()
                .overlay {
                    GeometryReader { geo in
                        currentPath
                            .applying(CGAffineTransform.identity.scaledBy(x: geo.size.width, y: geo.size.height))
                            .stroke(driedStrokeColor, style: strokeStyle)
                        driedPath
                            .applying(CGAffineTransform.identity.scaledBy(x: geo.size.width, y: geo.size.height))
                            .stroke(driedStrokeColor, style: strokeStyle)
                    }
                    Circle()
                        .fill(wetStrokeColor)
                        .frame(width: isDrawing ? 30 : 0, height: isDrawing ? 30 : 0)
                        .position(currentLocation)
                }
                .allowsHitTesting(false)
                .background {
                    GeometryReader { geo in
                        Color(white: 0.9)
                            .gesture(dragGesture(bounds: geo.size))
                    }
                }
                .allowsHitTesting(true)
                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 16, topTrailing: 16)))
                .onReceive(timer) { _ in updateWetness() }
            drawingToolBar
        }
    }

    func addPointToCurrent(point: CGPoint) {
        currentPoints.append(point)
        currentPath.addLine(to: point)
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
                action: onEraseButtonTapped,
                label: {
                    Image(systemName: "eraser.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                },
            )
            Spacer()
        }
    }

    func onEraseButtonTapped() {
        redoStack = []
        finishedPaths = []
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
                .typography(.largeTitle)
                .foregroundStyle(Color(white: 0.8))
                .aspectRatio(1, contentMode: .fit)
                .padding(148)
        },
    )
}
