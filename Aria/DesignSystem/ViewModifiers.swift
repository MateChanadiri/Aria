import SwiftUI

struct ShineModifier: ViewModifier {
    @State private var isShining = false

    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    colors: [.clear, .white.opacity(0.4), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .offset(x: isShining ? 200 : -200)
                .rotationEffect(.degrees(20))
                .mask(content)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                    isShining = true
                }
            }
    }
}

extension View {
    func shine() -> some View { modifier(ShineModifier()) }
}
