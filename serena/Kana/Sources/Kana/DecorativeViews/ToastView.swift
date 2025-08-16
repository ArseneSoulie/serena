//
//  ToastView.swift
//  SerenaApp
//
//  Created by A S on 06/08/2025.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .zIndex(1)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                ToastView(message: message)
                    .padding(.bottom, 50)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}
