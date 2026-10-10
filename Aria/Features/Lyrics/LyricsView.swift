import SwiftUI

struct LyricsView: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: theme.lyricsLineSpacing) {
                    if player.lyrics.isEmpty {
                        Text("No lyrics available.")
                            .font(.system(size: theme.lyricsSize * 0.6, weight: .semibold))
                            .foregroundStyle(theme.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 60)
                    } else {
                        ForEach(Array(player.lyrics.enumerated()), id: \.element.id) { index, line in
                            LyricLineView(line: line, isActive: index == player.currentLineIndex)
                                .id(line.id)
                                .onTapGesture { player.seek(to: line.start) }
                        }
                    }
                }
                .padding(.vertical, 100)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onChange(of: player.currentLineIndex) { _, newIndex in
                guard player.lyrics.indices.contains(newIndex) else { return }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                    proxy.scrollTo(player.lyrics[newIndex].id, anchor: .center)
                }
            }
        }
        .mask(LinearGradient(stops: [
            .init(color: .clear, location: 0),
            .init(color: .black, location: 0.15),
            .init(color: .black, location: 0.85),
            .init(color: .clear, location: 1)
        ], startPoint: .top, endPoint: .bottom))
    }
}

struct LyricLineView: View {
    let line: LyricLine
    let isActive: Bool
    @Environment(Theme.self) private var theme

    var body: some View {
        Text(line.text)
            .font(.system(size: theme.lyricsSize, weight: .bold, design: .rounded))
            .foregroundStyle(isActive ? theme.lyricsActiveColor : theme.lyricsInactiveColor)
            .blur(radius: isActive ? 0 : 1.2)
            .scaleEffect(isActive ? theme.lyricsScale : 1, anchor: .leading)
            .shadow(color: isActive && theme.lyricsGlow ? theme.lyricsActiveColor.opacity(0.55) : .clear, radius: isActive ? 22 : 0)
            .animation(.spring(response: 0.45, dampingFraction: 0.82), value: isActive)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
    }
}
