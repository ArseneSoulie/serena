import SwiftUI
import CoreLocation

public struct KanaDrawingView: View {
    @State var currentPath: Path = Path()
    @State var lastLocation: CGPoint = .zero
    @State var currentDragLocation: CGPoint = .zero
    @State var paths: [Path] = []
    
    @State var isDrawing: Bool = false
    
    let minimumDistanceToNextPoint: CGFloat = 5
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .onChanged {
                if !isDrawing {
                    currentPath = Path()
                    currentPath.move(to: $0.startLocation)
                }
                isDrawing = true
                
                let nextLocation = $0.location
                currentDragLocation = nextLocation
                if nextLocation.distance(lastLocation) > minimumDistanceToNextPoint {
                    lastLocation = nextLocation
                    currentPath.addLine(to: nextLocation)
                    wetPointsCount += 1
                    currentPoints += 1
                }
            }
            .onEnded { _ in
                isDrawing = false
                paths.append(currentPath)
                currentPath = Path()
                lastLocation = .zero
                withAnimation {
                    wetPointsCount = 0
                    currentPoints = 0
                }
            }
    }
    
    @State var currentPoints: Int = 0
    @State var wetPointsCount: Double = 0
    
    var currentWetness: Double {
        guard currentPoints > 0 else { return 0 }
        return 1 - (Double(floor(wetPointsCount)) / Double(currentPoints))
    }
    
    func updateWetness() {
        print(wetPointsCount)
        if wetPointsCount > 0 {
            wetPointsCount -= 0.1 * max(2,wetPointsCount/2)
            print(wetPointsCount)
        }
    }
    
    let timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    
    
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
                    
                    currentPath
                        .trimmedPath(from: currentWetness, to: 1)
                        .stroke(
                            Color(white: 0.1),
                            style: .init(lineWidth: 15,lineCap: .round,lineJoin: .round)
                        )
                    
                    Circle().fill(Color(white: 0.1))
                        .frame(width: isDrawing ? 25 : 0, height:  isDrawing ? 25 : 0)
                        .position(currentDragLocation)
                        .animation(.default, value: isDrawing)
                }
                .allowsHitTesting(false)
            }
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
