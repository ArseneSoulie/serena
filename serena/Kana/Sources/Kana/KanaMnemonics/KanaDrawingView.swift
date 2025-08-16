import SwiftUI
import CoreLocation

public struct KanaDrawingView: View {
    @State var currentPoint: CGPoint = .zero
    @State var currentPath: Path = Path()
    @State var lastLocation: CGPoint = .zero
    @State var paths: [Path] = []
    
    @State var isDrawing: Bool = false
    
    let kanaString: String
    
    init(kanaString: String) {
        self.kanaString = kanaString
    }
    
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
    
    let driedStrokeColor = Color(white: 0.2)
    let wetStrokeColor = Color.black
    
    let strokeStyle = StrokeStyle(lineWidth: 15,lineCap: .round,lineJoin: .round)
    
    public var body: some View {
        Text(kanaString)
            .foregroundStyle(Color(white: 0.8))
            .font(.system(size: 250, weight: .bold, design: .default))
            .padding(48)
            .aspectRatio(1, contentMode: .fill)
            .allowsHitTesting(false)
            .background { Color(white: 0.9).gesture(dragGesture) }
            .overlay {
                Group {
                    ForEach(paths, id: \.cgPath.boundingBox.hashValue) { path in
                        path.stroke(driedStrokeColor,style: strokeStyle)
                    }
                    currentPath.stroke(driedStrokeColor,style: strokeStyle)
                    
                    Circle()
                        .fill(wetStrokeColor)
                        .frame(width: isDrawing ? 25 : 0, height:  isDrawing ? 25 : 0)
                        .position(currentPoint)
                        .animation(.default, value: isDrawing)
                }
                .allowsHitTesting(false)
            }
            .animation(.default, body: {
                $0.overlay {
                    dryingPath
                        .stroke(wetStrokeColor,style: strokeStyle)
                        .opacity(isDrawing ? 1 : 0)
                }
            })
            .onReceive(timer) { _ in
                updateWetness()
            }
            .clipShape( RoundedRectangle(cornerRadius: 16))
        HStack {
            
        Button("Go back", systemImage: "arrowshape.turn.up.backward") {
            _ = paths.popLast()
        }
        
        Button("Clean", systemImage: "eraser.fill") {
            paths = []
        }
        }
    }
}

extension CGPoint {
    func distance(_ other: CGPoint) -> CGFloat {
        return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}

#Preview {
    KanaDrawingView(kanaString: "い")
}
