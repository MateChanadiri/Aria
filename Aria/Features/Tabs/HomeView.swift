import SwiftUI

struct HomeView: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Home").font(.largeTitle.bold()).foregroundStyle(theme.primaryText).padding(.horizontal).padding(.top, 8)
                    carousel
                    sectionGrid(title: "Recently Played")
                    sectionGrid(title: "Made For You")
                    NavigationLink("Customize Aria") { CustomizationStudio() }
                        .padding(.horizontal)
                }
                .padding(.bottom, 140)
            }
            .background(theme.background)
        }
    }

    private var carousel: some View {
        TabView {
            ForEach(DemoData.featured) { track in
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(colors: [theme.accent.opacity(0.8), theme.accent.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("FEATURED").font(.caption.bold()).foregroundStyle(.white.opacity(0.85))
                        Text(track.title).font(.title2.bold()).foregroundStyle(.white)
                        Text(track.artist).foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(20)
                }
                .clipShape(.rect(cornerRadius: 18))
                .padding(.horizontal)
                .onTapGesture { player.play(track, queue: DemoData.featured) }
            }
        }
        .tabViewStyle(.page)
        .frame(height: 220)
    }

    private func sectionGrid(title: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.title3.bold()).foregroundStyle(theme.primaryText).padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(DemoData.all) { track in
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(colors: [theme.accent.opacity(0.7), theme.accent.opacity(0.25)], startPoint: .top, endPoint: .bottom))
                                .frame(width: 160, height: 160)
                                .overlay(Image(systemName: "music.note").font(.system(size: 40)).foregroundStyle(.white.opacity(0.55)))
                            Text(track.title).font(.subheadline.weight(.semibold)).foregroundStyle(theme.primaryText).lineLimit(1).frame(width: 160, alignment: .leading)
                            Text(track.artist).font(.caption).foregroundStyle(theme.secondaryText).lineLimit(1).frame(width: 160, alignment: .leading)
                        }
                        .onTapGesture { player.play(track, queue: DemoData.all) }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
