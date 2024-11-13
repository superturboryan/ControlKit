//
//  Playback.swift
//  ControlKit
//

import AVFAudio
import MediaPlayer
import OSLog

public extension Control {
    
    /// ⏯️ Access and control the device's playback state.
    @MainActor
    enum Playback {
        
        /// Indicates whether audio playback is currently active in another app.
        ///
        /// This property checks `AVAudioSession.secondaryAudioShouldBeSilencedHint` to determine if audio is playing
        /// in another app. When `true`, it suggests that another app’s audio playback should silence secondary audio in your app.
        public static var isAudioPlaying: Bool {
            avAudioSession.secondaryAudioShouldBeSilencedHint
        }
        
        /// Toggles system media playback by activating or deactivating the shared `AVAudioSession`.
        ///
        /// This function pauses or resumes media playback across the system. If playback is paused by this function, it can typically be
        /// resumed, provided the app playing the content has not been terminated.
        ///
        /// - Note: This method uses the `.notifyOthersOnDeactivation` option to inform other audio sessions of state changes.
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
    
    /// 🍎 Manage playback from the **Apple Music** app.
    @MainActor
    enum AppleMusic {
        
        /// Indicates whether media is currently being played by the **Apple Music** app.
        ///
        /// To monitor changes to `isPlaying`, subscribe to the **`@Published`** property `AppleMusicController/isPlaying`
        /// from `Controllers`.
        public static var isPlaying: Bool {
            systemMusicPlayer.playbackState.isPlaying
        }
        
        /// Toggles the playback of the **Apple Music** app.
        ///
        /// This method pauses playback if media is currently playing, or resumes playback if it is paused.
        public static func togglePlayPause() {
            if systemMusicPlayer.playbackState.isPlaying {
                systemMusicPlayer.pause()
            } else {
                systemMusicPlayer.play()
            }
        }
        
        /// Sends the "next track command" to the **Apple Music** app.
        ///
        /// This method advances playback to the next available item in the queue.
        public static func skipToNextTrack() {
            systemMusicPlayer.skipToNextItem()
        }
        
        /// Sends the "previous track command" to the **Apple Music** app.
        ///
        /// This method advances playback to the next available item in the player's queue.
        public static func skipToPreviousTrack() {
            systemMusicPlayer.skipToPreviousItem()
        }
    }
}

private extension Control.Playback {
    
    static let avAudioSession = AVAudioSession.sharedInstance()
    
    static let log = Logger(subsystem: Control.subsystem, category: "Playback")
}

private extension Control.Playback.AppleMusic {
    
    nonisolated(unsafe)
    static let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
}
