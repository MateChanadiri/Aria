import SwiftUI

struct RadioView: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 64))
                    .foregroundStyle(theme.accent)
                Text("Aria Radio").font(.largeTitle.bold()).foregroundStyle(theme.primaryText)
                Text("Start a demo mix from the featured tracks.")
                    .foregroundStyle(theme.secondaryText)
                Button("Play Featured Mix") {
                    if let first = DemoData.featured.first {
                        player.play(first, queue: DemoData.featured)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(theme.background)
            .navigationTitle("Radio")
        }
    }
}
