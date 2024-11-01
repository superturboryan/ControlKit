//
//  Playback.swift
//  ControlKit
//

import AVFAudio
import MediaPlayer

public extension Control {
    
    enum Playback {
        
        /// Alias for `AVAudioSession.secondaryAudioShouldBeSilencedHint`.
        public static var isAudioPlaying: Bool { avAudioSession.secondaryAudioShouldBeSilencedHint }
        
        private static let avAudioSession = AVAudioSession.sharedInstance()
        
        /// Toggles system media playback by activating or disactivating the shared `AVAudioSession`.
        ///
        /// Playback that has been paused by this function can normally be resumed if the app playing the content has not been terminated.
        public static func togglePlayPause() {
            try? avAudioSession.setActive(
                isAudioPlaying,
                options: .notifyOthersOnDeactivation
            )
        }
    }
}

public extension Control.Playback {
    
    enum AppleMusic {
        
        /// Subscribe to `isPlaying` via ``AppleMusicController/isPlaying`` `@Published` property.
        package static var isPlaying: Bool { systemMusicPlayer.playbackState.isPlaying }
        
        nonisolated(unsafe)
        private static let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
        
        public static func togglePlayPause() {
            systemMusicPlayer.playbackState == .playing ?
            systemMusicPlayer.pause() :
            systemMusicPlayer.play()
        }
        
        public static func skipToNextTrack() {
            systemMusicPlayer.skipToNextItem()
        }
        
        public static func skipToPreviousTrack() {
            systemMusicPlayer.skipToPreviousItem()
        }
    }
}

private extension MPMusicPlaybackState {
    
    var isPlaying: Bool {
        self == .playing
        || self == .seekingForward
        || self == .seekingBackward
    }
}
