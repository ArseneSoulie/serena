//
//  NavigationRootView.swift
//  Navigation
//
//  Created by A S on 11/08/2025.
//

import SwiftUI

struct NavigationRootView<Content: View>: View {
    var content: Content
    
    var body: some View {
        content
    }
}
