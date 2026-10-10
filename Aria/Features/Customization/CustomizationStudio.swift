import SwiftUI

struct CustomizationStudio: View {
    @Environment(Theme.self) private var theme

    var body: some View {
        @Bindable var theme = theme
        NavigationStack {
            Form {
                Section("Appearance") {
                    ColorPicker("Accent", selection: $theme.accent)
                    ColorPicker("Background", selection: $theme.background)
                    ColorPicker("Primary Text", selection: $theme.primaryText)
                    ColorPicker("Secondary Text", selection: $theme.secondaryText)
                    Toggle("Use system appearance", isOn: $theme.useSystemScheme)
                    if !theme.useSystemScheme {
                        Toggle("Dark appearance", isOn: $theme.forcedDark)
                    }
                }
                Section("Player") {
                    Picker("Layout", selection: $theme.playerLayout) {
                        ForEach(PlayerLayout.allCases, id: \.self) { layout in
                            Text(layout.rawValue.capitalized).tag(layout)
                        }
                    }
                    HStack {
                        Text("Artwork corner")
                        Slider(value: $theme.artworkCornerRadius, in: 0...40)
                    }
                    Toggle("Artwork glow", isOn: $theme.artworkGlow)
                    HStack {
                        Text("Mini player height")
                        Slider(value: $theme.miniPlayerHeight, in: 44...100)
                    }
                }
                Section("Typography") {
                    HStack { Text("Title size"); Slider(value: $theme.titleSize, in: 14...34) }
                    HStack { Text("Lyrics size"); Slider(value: $theme.lyricsSize, in: 18...56) }
                    HStack { Text("Lyrics spacing"); Slider(value: $theme.lyricsLineSpacing, in: 8...60) }
                }
                Section("Lyrics") {
                    ColorPicker("Active color", selection: $theme.lyricsActiveColor)
                    ColorPicker("Inactive color", selection: $theme.lyricsInactiveColor)
                    Toggle("Glow", isOn: $theme.lyricsGlow)
                    HStack { Text("Active scale"); Slider(value: $theme.lyricsScale, in: 1...1.25) }
                }
                Section("Tabs") {
                    ForEach(Tab.allCases) { tab in
                        Toggle(tab.rawValue, isOn: Binding(
                            get: { theme.enabledTabs.contains(tab) },
                            set: { enabled in
                                if enabled {
                                    if !theme.enabledTabs.contains(tab) { theme.enabledTabs.append(tab) }
                                } else if theme.enabledTabs.count > 1 {
                                    theme.enabledTabs.removeAll { $0 == tab }
                                }
                            }
                        ))
                    }
                }
                Section {
                    Button("Save") { theme.save() }
                    Button("Reset to defaults", role: .destructive) { theme.reset() }
                }
            }
            .navigationTitle("Customize")
        }
    }
}
