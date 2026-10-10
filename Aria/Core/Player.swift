import AVFoundation
import MediaPlayer
import Observation
import UIKit

@Observable
final class Player {
    static let shared = Player()

    var current: Track?
    var queue: [Track] = []
    var index = 0
    var isPlaying = false
    var progress: TimeInterval = 0
    var duration: TimeInterval = 0
    var lyrics: [LyricLine] = []
    var currentLineIndex = 0

    @ObservationIgnored private var avPlayer: AVAudioPlayer?
    @ObservationIgnored private var timer: Timer?

    private init() { setupRemoteCommands() }

    func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
    }

    func play(_ track: Track, queue: [Track]? = nil) {
        if let queue, !queue.isEmpty {
            self.queue = queue
            index = queue.firstIndex(of: track) ?? 0
        } else {
            self.queue = [track]
            index = 0
        }
        load(track)
    }

    private func load(_ track: Track) {
        timer?.invalidate()
        avPlayer?.stop()
        current = track
        progress = 0
        duration = track.duration

        guard let url = track.fileURL else {
            isPlaying = true
            fakeTick()
            updateNowPlaying()
            return
        }

        do {
            avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer?.prepareToPlay()
            duration = avPlayer?.duration ?? track.duration
            avPlayer?.play()
            isPlaying = true
            startTimer()
        } catch {
            print("Playback error:", error)
            isPlaying = false
        }
        updateNowPlaying()
    }

    func togglePlay() {
        guard current != nil else { return }
        isPlaying.toggle()
        if let player = avPlayer {
            if isPlaying { player.play() } else { player.pause() }
        } else if isPlaying {
            fakeTick()
        }
        updateNowPlaying()
    }

    func next() {
        guard !queue.isEmpty else { return }
        index = (index + 1) % queue.count
        load(queue[index])
    }

    func previous() {
        guard !queue.isEmpty else { return }
        if progress > 3 {
            seek(to: 0)
        } else {
            index = (index - 1 + queue.count) % queue.count
            load(queue[index])
        }
    }

    func seek(to time: TimeInterval) {
        progress = max(0, min(time, duration))
        avPlayer?.currentTime = progress
        updateNowPlaying()
    }

    func skip(by time: TimeInterval) { seek(to: progress + time) }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.progress = self.avPlayer?.currentTime ?? self.progress
            self.tickLyrics()
            if self.duration > 0 && self.progress >= self.duration - 0.1 { self.next() }
        }
    }

    private func fakeTick() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let self, self.isPlaying else { return }
            self.progress = min(self.progress + 0.25, self.duration)
            self.tickLyrics()
            if self.duration > 0 && self.progress >= self.duration { self.next() }
        }
    }

    private func tickLyrics() {
        guard !lyrics.isEmpty else { return }
        var lineIndex = 0
        for (idx, line) in lyrics.enumerated() {
            if progress >= line.start { lineIndex = idx } else { break }
        }
        currentLineIndex = lineIndex
    }

    func setLyrics(_ lines: [LyricLine]) {
        lyrics = lines
        currentLineIndex = 0
    }

    private func updateNowPlaying() {
        guard let track = current else { return }
        let info: [String: Any] = [
            MPMediaItemPropertyTitle: track.title,
            MPMediaItemPropertyArtist: track.artist,
            MPMediaItemPropertyAlbumTitle: track.album,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: progress,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
    }

    private func setupRemoteCommands() {
        let commands = MPRemoteCommandCenter.shared()
        commands.playCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            if !self.isPlaying { self.togglePlay() }
            return .success
        }
        commands.pauseCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            if self.isPlaying { self.togglePlay() }
            return .success
        }
        commands.nextTrackCommand.addTarget { [weak self] _ in
            self?.next()
            return .success
        }
        commands.previousTrackCommand.addTarget { [weak self] _ in
            self?.previous()
            return .success
        }
        commands.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self?.seek(to: event.positionTime)
            return .success
        }
    }
}
