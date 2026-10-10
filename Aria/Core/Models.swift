import Foundation

struct Track: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var artist: String
    var album: String
    var duration: TimeInterval
    var fileURL: URL?
    var artworkURL: URL?

    init(title: String, artist: String, album: String = "", duration: TimeInterval = 210, fileURL: URL? = nil, artworkURL: URL? = nil) {
        self.id = UUID()
        self.title = title
        self.artist = artist
        self.album = album
        self.duration = duration
        self.fileURL = fileURL
        self.artworkURL = artworkURL
    }
}

struct LyricLine: Identifiable, Hashable {
    let id = UUID()
    var start: TimeInterval
    var text: String
}

enum PlayerLayout: String, CaseIterable, Codable {
    case classic, largeArtwork, vinyl, minimal
}

enum Tab: String, CaseIterable, Identifiable, Codable {
    case home = "Home"
    case new = "New"
    case radio = "Radio"
    case library = "Library"
    case search = "Search"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .new: "sparkles"
        case .radio: "dot.radiowaves.left.and.right"
        case .library: "square.stack.fill"
        case .search: "magnifyingglass"
        }
    }
}

enum DemoData {
    static let featured: [Track] = [
        Track(title: "Cherry Waves", artist: "Deftones", album: "Saturday Night Wrist", duration: 300),
        Track(title: "When the Sun Hits", artist: "Slowdive", album: "Souvlaki", duration: 290),
        Track(title: "Join Me in Death", artist: "HIM", album: "Razorblade Romance", duration: 220)
    ]
    static let all: [Track] = featured + [
        Track(title: "Lhabia", artist: "Deftones", album: "Adrenaline", duration: 250),
        Track(title: "Dagger", artist: "Slowdive", album: "Souvlaki", duration: 240),
        Track(title: "World's A F**k", artist: "Sematary & Ghost Mountain", duration: 190)
    ]
}
