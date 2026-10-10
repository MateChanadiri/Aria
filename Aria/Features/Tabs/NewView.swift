import SwiftUI

struct NewView: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player

    var body: some View {
        NavigationStack {
            List(DemoData.featured) { track in
                Button { player.play(track, queue: DemoData.featured) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(track.title).foregroundStyle(theme.primaryText)
                        Text(track.artist).font(.caption).foregroundStyle(theme.secondaryText)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.background)
            .navigationTitle("New")
        }
    }
}
