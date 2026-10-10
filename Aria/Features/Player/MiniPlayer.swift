import SwiftUI

struct MiniPlayer: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player

    var body: some View {
        HStack(spacing: 12) {
            artwork(size: 44)
            VStack(alignment: .leading, spacing: 1) {
                Text(player.current?.title ?? "—")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(theme.primaryText)
                    .lineLimit(1)
                Text(player.current?.artist ?? "")
                    .font(.system(size: 12))
                    .foregroundStyle(theme.secondaryText)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            Button { player.togglePlay() } label: {
                Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(theme.primaryText)
                    .frame(width: 40, height: 40)
            }
            Button { player.next() } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(theme.primaryText)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.horizontal, 10)
        .frame(height: theme.miniPlayerHeight)
        .glassBackground(cornerRadius: theme.miniPlayerHeight / 2, tint: theme.accent)
    }

    @ViewBuilder
    private func artwork(size: CGFloat) -> some View {
        Group {
            if let url = player.current?.artworkURL {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: { placeholderArt }
            } else { placeholderArt }
        }
        .frame(width: size, height: size)
        .clipShape(.rect(cornerRadius: 8))
    }

    private var placeholderArt: some View {
        LinearGradient(colors: [theme.accent.opacity(0.9), theme.accent.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay(Image(systemName: "music.note").foregroundStyle(.white.opacity(0.7)))
    }
}
