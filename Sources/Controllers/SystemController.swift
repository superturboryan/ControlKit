//
//  SystemController.swift
//  ControlKit
//

import Control
import SwiftUI

/// Controller of controllers 👑
@MainActor
public final class SystemController: ObservableObject {
    
    public enum PlaybackType { case appleMusic, spotify, avAudio }
    
    @Published public var selectedPlaybackType: PlaybackType = .avAudio
    
    @Published public private(set) var isAudioPlaying = false
    @Published public private(set) var isMuted = false
    
    @Published public private(set) var appleMusic = AppleMusicController()
    @Published public private(set) var spotify: SpotifyController!
    @Published public private(set) var volume = VolumeController()
        
    public init(spotifyConfig: SpotifyController.SpotifyConfig = .empty) {
        spotify = SpotifyController(config: spotifyConfig)
    }
}

extension SystemController: PlaybackController {
    
    /// Toggles play-pause according to the `selectedPlaybackType`, mimicking the playback controls in Control Center.
    public func togglePlayPause() {
        switch selectedPlaybackType {
            
        case .appleMusic:
            appleMusic.togglePlayPause()
        case .spotify:
            spotify.togglePlayPause()
        case .avAudio:
            Control.Playback.togglePlayPause()
        }
        
        updateIsAudioPlaying()
    }
    
    /// Skips to the next track according to the `selectedPlaybackType`, mimicking the playback controls in Control Center.
    ///
    /// - Note: When `avAudio` is the `selectedPlaybackType` this method will attempt to skip to the next track for **both
    /// the Apple Music and Spotify apps**. It's not possible to skip to the next track for apps besides Apple Music and Spotify.
    public func skipToNextTrack() {
        switch selectedPlaybackType {
            
        case .appleMusic:
            appleMusic.skipToNextTrack()
        case .spotify:
            spotify.skipToNextTrack()
        case .avAudio:
            appleMusic.skipToNextTrack()
            spotify.skipToNextTrack()
        }
    }
    
    /// Skips to the previous track according to the `selectedPlaybackType`, mimicking the playback controls in Control Center.
    ///
    /// - Note: When `avAudio` is the `selectedPlaybackType` this method will attempt to skip to the previous track for **both
    /// the Apple Music and Spotify apps**. It's not possible to skip to the previous track for apps besides Apple Music and Spotify.
    public func skipToPreviousTrack() {
        switch selectedPlaybackType {
            
        case .appleMusic:
            appleMusic.skipToPreviousTrack()
        case .spotify:
            spotify.skipToPreviousTrack()
        case .avAudio:
            appleMusic.skipToPreviousTrack()
            spotify.skipToPreviousTrack()
        }
    }
    
    private func updateIsAudioPlaying() {
        switch selectedPlaybackType {
            
        case .appleMusic:
            isAudioPlaying = appleMusic.isPlaying
        case .spotify:
            isAudioPlaying = spotify.isPlaying
        case .avAudio:
            isAudioPlaying = Control.Playback.isAudioPlaying
        }
    }
}

extension SystemController {
    
    public func vibrate() {
        Control.Haptics.vibrate()
    }
}
