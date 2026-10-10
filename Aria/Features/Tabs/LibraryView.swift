import SwiftUI

struct LibraryView: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Library").font(.largeTitle.bold()).foregroundStyle(theme.primaryText).padding()
                    ForEach(DemoData.all) { track in
                        Button { player.play(track, queue: DemoData.all) } label: {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(theme.accent.opacity(0.6))
                                    .frame(width: 48, height: 48)
                                    .overlay(Image(systemName: "music.note").foregroundStyle(.white.opacity(0.75)))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(track.title).font(.body.weight(.semibold)).foregroundStyle(theme.primaryText)
                                    Text(track.artist).font(.subheadline).foregroundStyle(theme.secondaryText)
                                }
                                Spacer()
                                Image(systemName: "ellipsis").foregroundStyle(theme.secondaryText)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                        Divider().background(theme.secondaryText.opacity(0.2)).padding(.leading, 76)
                    }
                    NavigationLink("Customization Studio") { CustomizationStudio() }.padding()
                }
                .padding(.bottom, 140)
            }
            .background(theme.background)
        }
    }
}
