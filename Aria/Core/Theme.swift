import SwiftUI
import UIKit

@Observable
@MainActor
final class Theme {
    static let shared = Theme()
    private let key = "aria.theme.v1"

    var accent: Color = .red
    var background: Color = .black
    var primaryText: Color = .white
    var secondaryText: Color = Color.white.opacity(0.6)
    var useSystemScheme = true
    var forcedDark = true

    var fontFamily = "SF Pro"
    var titleSize: CGFloat = 22
    var lyricsSize: CGFloat = 34
    var lyricsLineSpacing: CGFloat = 22

    var playerLayout: PlayerLayout = .classic
    var artworkCornerRadius: CGFloat = 14
    var miniPlayerHeight: CGFloat = 64
    var artworkGlow = false

    var lyricsActiveColor: Color = .white
    var lyricsInactiveColor: Color = Color.white.opacity(0.35)
    var lyricsGlow = true
    var lyricsScale: CGFloat = 1.05

    var animationSpeed: Double = 1
    var enabledTabs: [Tab] = Tab.allCases

    var colorScheme: ColorScheme? {
        useSystemScheme ? nil : (forcedDark ? .dark : .light)
    }

    private init() { load() }

    func save() {
        guard let encoded = try? JSONEncoder().encode(Snapshot(self)) else { return }
        UserDefaults.standard.set(encoded, forKey: key)
    }

    func load() {
        guard let raw = UserDefaults.standard.data(forKey: key),
              let snapshot = try? JSONDecoder().decode(Snapshot.self, from: raw) else { return }
        apply(snapshot)
    }

    func reset() {
        UserDefaults.standard.removeObject(forKey: key)
        accent = .red
        background = .black
        primaryText = .white
        secondaryText = Color.white.opacity(0.6)
        useSystemScheme = true
        forcedDark = true
        fontFamily = "SF Pro"
        titleSize = 22
        lyricsSize = 34
        lyricsLineSpacing = 22
        playerLayout = .classic
        artworkCornerRadius = 14
        miniPlayerHeight = 64
        artworkGlow = false
        lyricsActiveColor = .white
        lyricsInactiveColor = Color.white.opacity(0.35)
        lyricsGlow = true
        lyricsScale = 1.05
        animationSpeed = 1
        enabledTabs = Tab.allCases
    }

    private func apply(_ s: Snapshot) {
        accent = Color(hex: s.accent)
        background = Color(hex: s.background)
        primaryText = Color(hex: s.primaryText)
        secondaryText = Color(hex: s.secondaryText)
        useSystemScheme = s.useSystemScheme
        forcedDark = s.forcedDark
        fontFamily = s.fontFamily
        titleSize = s.titleSize
        lyricsSize = s.lyricsSize
        lyricsLineSpacing = s.lyricsLineSpacing
        playerLayout = s.playerLayout
        artworkCornerRadius = s.artworkCornerRadius
        miniPlayerHeight = s.miniPlayerHeight
        artworkGlow = s.artworkGlow
        lyricsActiveColor = Color(hex: s.lyricsActive)
        lyricsInactiveColor = Color(hex: s.lyricsInactive)
        lyricsGlow = s.lyricsGlow
        lyricsScale = s.lyricsScale
        animationSpeed = s.animationSpeed
        enabledTabs = s.enabledTabs.isEmpty ? Tab.allCases : s.enabledTabs
    }

    struct Snapshot: Codable {
        var accent: String
        var background: String
        var primaryText: String
        var secondaryText: String
        var useSystemScheme: Bool
        var forcedDark: Bool
        var fontFamily: String
        var titleSize: CGFloat
        var lyricsSize: CGFloat
        var lyricsLineSpacing: CGFloat
        var playerLayout: PlayerLayout
        var artworkCornerRadius: CGFloat
        var miniPlayerHeight: CGFloat
        var artworkGlow: Bool
        var lyricsActive: String
        var lyricsInactive: String
        var lyricsGlow: Bool
        var lyricsScale: CGFloat
        var animationSpeed: Double
        var enabledTabs: [Tab]

        init(_ t: Theme) {
            accent = t.accent.toHex()
            background = t.background.toHex()
            primaryText = t.primaryText.toHex()
            secondaryText = t.secondaryText.toHex()
            useSystemScheme = t.useSystemScheme
            forcedDark = t.forcedDark
            fontFamily = t.fontFamily
            titleSize = t.titleSize
            lyricsSize = t.lyricsSize
            lyricsLineSpacing = t.lyricsLineSpacing
            playerLayout = t.playerLayout
            artworkCornerRadius = t.artworkCornerRadius
            miniPlayerHeight = t.miniPlayerHeight
            artworkGlow = t.artworkGlow
            lyricsActive = t.lyricsActiveColor.toHex()
            lyricsInactive = t.lyricsInactiveColor.toHex()
            lyricsGlow = t.lyricsGlow
            lyricsScale = t.lyricsScale
            animationSpeed = t.animationSpeed
            enabledTabs = t.enabledTabs
        }
    }
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: s).scanHexInt64(&value)
        let r, g, b, a: Double
        if s.count == 8 {
            r = Double((value >> 24) & 0xFF) / 255
            g = Double((value >> 16) & 0xFF) / 255
            b = Double((value >> 8) & 0xFF) / 255
            a = Double(value & 0xFF) / 255
        } else {
            r = Double((value >> 16) & 0xFF) / 255
            g = Double((value >> 8) & 0xFF) / 255
            b = Double(value & 0xFF) / 255
            a = 1
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    func toHex() -> String {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }
}
