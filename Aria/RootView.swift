import SwiftUI

struct RootView: View {
    @Environment(Theme.self) private var theme
    @Environment(Player.self) private var player
    @State private var selection: Tab = .home
    @State private var showFullPlayer = false

    var body: some View {
        TabView(selection: $selection) {
            ForEach(theme.enabledTabs) { tab in
                tabContent(tab)
                    .tag(tab)
                    .tabItem { Label(tab.rawValue, systemImage: tab.icon) }
            }
        }
        .tabViewBottomAccessory {
            if player.current != nil && !showFullPlayer {
                MiniPlayer()
                    .padding(.horizontal, 8)
                    .onTapGesture { showFullPlayer = true }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .sheet(isPresented: $showFullPlayer) {
            FullPlayer()
                .presentationDragIndicator(.hidden)
        }
    }

    @ViewBuilder
    private func tabContent(_ tab: Tab) -> some View {
        switch tab {
        case .home: HomeView()
        case .new: NewView()
        case .radio: RadioView()
        case .library: LibraryView()
        case .search: SearchView()
        }
    }
}
