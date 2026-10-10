import SwiftUI

@main
struct AriaApp: App {
    @State private var theme = Theme.shared
    @State private var player = Player.shared

    init() {
        Player.shared.configureAudioSession()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(theme)
                .environment(player)
                .preferredColorScheme(theme.colorScheme)
                .tint(theme.accent)
        }
    }
}
