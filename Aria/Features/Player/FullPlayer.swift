import SwiftUI

struct FullPlayer: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player
    @Environment(\.dismiss) private var dismiss
    @State private var showLyrics = false

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            VStack(spacing: 24) {
                Capsule().fill(theme.secondaryText.opacity(0.5)).frame(width: 40, height: 5).padding(.top, 8)
                Spacer(minLength: 0)
                if showLyrics {
                    LyricsView().transition(.opacity)
                } else {
                    artwork.transition(.opacity)
                }
                Spacer(minLength: 0)
                metadata
                scrubber
                controls
                bottomBar
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .presentationDragIndicator(.hidden)
    }

    private var artwork: some View {
        Group {
            if let url = player.current?.artworkURL {
                AsyncImage(url: url) { image in image.resizable().scaledToFit() } placeholder: { placeholderArt }
            } else { placeholderArt }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .clipShape(.rect(cornerRadius: theme.artworkCornerRadius))
        .shadow(color: theme.artworkGlow ? theme.accent.opacity(0.6) : .black.opacity(0.4), radius: theme.artworkGlow ? 40 : 20, y: 12)
        .scaleEffect(player.isPlaying ? 1 : 0.94)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: player.isPlaying)
    }

    private var placeholderArt: some View {
        LinearGradient(colors: [theme.accent.opacity(0.9), theme.accent.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay(Image(systemName: "music.note").font(.system(size: 80)).foregroundStyle(.white.opacity(0.5)))
    }

    private var metadata: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.current?.title ?? "Not playing")
                    .font(.system(size: theme.titleSize, weight: .bold))
                    .foregroundStyle(theme.primaryText)
                    .lineLimit(1)
                Text(player.current?.artist ?? "")
                    .font(.system(size: 18))
                    .foregroundStyle(theme.secondaryText)
                    .lineLimit(1)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "star").font(.system(size: 20)).foregroundStyle(theme.primaryText).frame(width: 44, height: 44)
            }
            Button {} label: {
                Image(systemName: "ellipsis").font(.system(size: 20)).foregroundStyle(theme.primaryText).frame(width: 44, height: 44)
            }
        }
    }

    private var scrubber: some View {
        VStack(spacing: 6) {
            Slider(value: Binding(get: { player.progress }, set: { player.seek(to: $0) }), in: 0...max(player.duration, 1))
                .tint(theme.primaryText)
            HStack {
                Text(timeString(player.progress))
                Spacer()
                Text("-" + timeString(max(0, player.duration - player.progress)))
            }
            .font(.system(size: 12, weight: .medium).monospacedDigit())
            .foregroundStyle(theme.secondaryText)
        }
    }

    private var controls: some View {
        HStack(spacing: 32) {
            Button { player.previous() } label: {
                Image(systemName: "backward.fill").font(.system(size: 30, weight: .semibold)).foregroundStyle(theme.primaryText).frame(width: 60, height: 60)
            }
            Button { player.togglePlay() } label: {
                Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(theme.background)
                    .frame(width: 74, height: 74)
                    .background(theme.primaryText, in: .circle)
            }
            Button { player.next() } label: {
                Image(systemName: "forward.fill").font(.system(size: 30, weight: .semibold)).foregroundStyle(theme.primaryText).frame(width: 60, height: 60)
            }
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 0) {
            Spacer()
            Button { withAnimation(.easeInOut(duration: 0.25)) { showLyrics.toggle() } } label: {
                Image(systemName: showLyrics ? "quote.bubble.fill" : "quote.bubble").font(.system(size: 20)).foregroundStyle(theme.primaryText).frame(width: 60, height: 44)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "list.bullet").font(.system(size: 20)).foregroundStyle(theme.primaryText).frame(width: 60, height: 44)
            }
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "chevron.down").font(.system(size: 20, weight: .semibold)).foregroundStyle(theme.primaryText).frame(width: 60, height: 44)
            }
            Spacer()
        }
        .frame(height: 44)
    }

    private var backgroundGradient: some View {
        LinearGradient(colors: [theme.accent.opacity(0.35), theme.background], startPoint: .top, endPoint: .bottom)
            .overlay(theme.background.opacity(0.6))
    }

    private func timeString(_ time: TimeInterval) -> String {
        String(format: "%d:%02d", Int(time) / 60, Int(time) % 60)
    }
}
