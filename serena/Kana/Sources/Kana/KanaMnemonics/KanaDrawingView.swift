import SwiftUI
import CoreLocation

public struct KanaDrawingView: View {
    @State var currentPoint: CGPoint = .zero
    @State var currentPath: Path = Path()
    @State var lastLocation: CGPoint = .zero
    @State var paths: [Path] = []
    
    @State var isDrawing: Bool = false
    
    let minimumDistanceToNextPoint: CGFloat = 5
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
                paths.append(currentPath)
                currentPath = Path()
                lastLocation = .zero
            }
    }
    
    @State var currentPoints: [CGPoint] = []
    
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
    
    let timer = Timer.publish(every: 0.02, on: .current, in: .common).autoconnect()
    
    var dryingPath : Path {
        guard let firstPoint = currentPoints.first else { return Path() }
        return Path { path in
            path.move(to: firstPoint)
            for point in currentPoints {
                path.addLine(to: point)
            }
        }
    }
    
    public var body: some View {
        Rectangle()
            .fill( Color(white: 0.8) )
            .gesture(dragGesture)
            .overlay {
                Group {
                    ForEach(paths, id: \.cgPath.boundingBox.hashValue) { path in
                        path.stroke(Color(white: 0.2),style: .init(lineWidth: 15,lineCap: .round,lineJoin: .round))
                    }
                    currentPath.stroke(Color(white: 0.2),style: .init(lineWidth: 15,lineCap: .round,lineJoin: .round))
                    
                    Circle().fill(Color(white: 0.1))
                        .frame(width: isDrawing ? 25 : 0, height:  isDrawing ? 25 : 0)
                        .position(currentPoint)
                        .animation(.default, value: isDrawing)
                }
                .allowsHitTesting(false)
            }
            .animation(.default, body: {
                $0.overlay {
                    dryingPath
                        .stroke(.black,style: .init(lineWidth: 15,lineCap: .round,lineJoin: .round))
                        .opacity(isDrawing ? 1 : 0)
                }
            })
            .onReceive(timer) { _ in
                updateWetness()
            }
        
        Button("Go back") {
            _ = paths.popLast()
        }
        
        Button("Clean") {
            paths = []
        }
    }
}

extension CGPoint {
    func distance(_ other: CGPoint) -> CGFloat {
        return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}

#Preview {
    KanaDrawingView()
}
