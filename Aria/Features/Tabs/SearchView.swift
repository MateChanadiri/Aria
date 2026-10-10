import SwiftUI

struct SearchView: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player
    @State private var query = ""

    private var results: [Track] {
        guard !query.isEmpty else { return DemoData.all }
        return DemoData.all.filter { $0.title.localizedCaseInsensitiveContains(query) || $0.artist.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Search").font(.largeTitle.bold()).foregroundStyle(theme.primaryText)
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundStyle(theme.secondaryText)
                        TextField("Artists, songs, albums", text: $query).textFieldStyle(.plain).foregroundStyle(theme.primaryText)
                    }
                    .padding(12)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                    ForEach(results) { track in
                        Button { player.play(track, queue: results) } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(track.title).foregroundStyle(theme.primaryText)
                                    Text(track.artist).font(.caption).foregroundStyle(theme.secondaryText)
                                }
                                Spacer()
                                Image(systemName: "play.circle").foregroundStyle(theme.accent)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                .padding()
            }
            .background(theme.background)
        }
    }
}
