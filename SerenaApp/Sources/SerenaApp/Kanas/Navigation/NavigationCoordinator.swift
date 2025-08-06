import SwiftUI

@Observable
@MainActor
class NavigationCoordinator {
    var path: [Destination] = []
    
    func push(_ destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func binding<T>(for keyPath: ReferenceWritableKeyPath<NavigationCoordinator, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}


