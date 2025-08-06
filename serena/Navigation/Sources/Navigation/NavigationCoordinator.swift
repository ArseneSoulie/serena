import SwiftUI

@Observable
@MainActor
public class NavigationCoordinator {
    public init() {}
    
    public var path: [Destination] = []
    
    public func push(_ destination: Destination) {
        path.append(destination)
    }
    
    public func pop() {
        _ = path.popLast()
    }
    
    public func popToRoot() {
        path.removeAll()
    }
    
    public func binding<T>(for keyPath: ReferenceWritableKeyPath<NavigationCoordinator, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}


