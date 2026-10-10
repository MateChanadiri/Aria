import SwiftUI

struct GlassBackground: ViewModifier {
    var cornerRadius: CGFloat = 16
    var tint: Color? = nil

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: .rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke((tint ?? .white).opacity(tint == nil ? 0.12 : 0.3), lineWidth: 0.5)
            }
            .shadow(color: (tint ?? .black).opacity(tint == nil ? 0.3 : 0.15), radius: 20, y: 10)
    }
}

extension View {
    func glassBackground(cornerRadius: CGFloat = 16, tint: Color? = nil) -> some View {
        modifier(GlassBackground(cornerRadius: cornerRadius, tint: tint))
    }
}
