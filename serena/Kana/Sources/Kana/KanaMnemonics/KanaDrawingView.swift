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
                }
            }
            .onEnded { _ in
                isDrawing = false
                paths.append(currentPath)
                currentPath = Path()
                lastLocation = .zero
            }
    }
    
    public var body: some View {
        Rectangle()
            .fill( Color(white: 0.8) )
            .gesture(dragGesture)
            .overlay {
                ForEach(paths, id: \.cgPath.boundingBox.hashValue) { path in
                    path.stroke(Color(white: 0.2),style: .init(lineWidth: 15,lineCap: .round,lineJoin: .round))
                }
                currentPath.stroke(Color(white: 0),style: .init(lineWidth: 15,lineCap: .round,lineJoin: .round))
                Circle().fill(Color(white: 0.1))
                    .frame(width: isDrawing ? 25 : 0, height:  isDrawing ? 25 : 0)
                    .position(currentDragLocation)
                    .animation(.default, value: isDrawing)
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
