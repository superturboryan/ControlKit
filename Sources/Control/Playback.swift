//
//  Playback.swift
//  ControlKit
//

import AVFAudio
import MediaPlayer
import OSLog

public extension Control {
    
    @MainActor
    enum Playback {
        
        /// Alias for `AVAudioSession.secondaryAudioShouldBeSilencedHint`.
        public static var isAudioPlaying: Bool { avAudioSession.secondaryAudioShouldBeSilencedHint }
        
        private static let avAudioSession = AVAudioSession.sharedInstance()
        
        /// Toggles system media playback by activating or disactivating the shared `AVAudioSession`.
        ///
        /// Playback that has been paused by this function can normally be resumed if the app playing the content has not been terminated.
        public static func togglePlayPause() {
            do {
                try avAudioSession.setActive(
                    isAudioPlaying,
                    options: .notifyOthersOnDeactivation
                )
            } catch {
                log.error("\(error.localizedDescription)")
            }
        }
    }
}

public extension Control.Playback {
    
    @MainActor
    enum AppleMusic {
        
        /// Subscribe to `isPlaying` via ``AppleMusicController/isPlaying`` `@Published` property.
        package static var isPlaying: Bool { systemMusicPlayer.playbackState.isPlaying }
        
        nonisolated(unsafe)
        private static let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
        
        public static func togglePlayPause() {
            if systemMusicPlayer.playbackState.isPlaying {
                systemMusicPlayer.pause()
            } else {
                systemMusicPlayer.play()
            }
        }
        
        public static func skipToNextTrack() {
            systemMusicPlayer.skipToNextItem()
        }
        
        public static func skipToPreviousTrack() {
            systemMusicPlayer.skipToPreviousItem()
        }
    }
}

private extension Control.Playback {
    
    static let log = Logger(subsystem: Control.subsystem, category: "Playback")
}

private extension MPMusicPlaybackState {
    
    var isPlaying: Bool {
        self == .playing
        || self == .seekingForward
        || self == .seekingBackward
    }
}
