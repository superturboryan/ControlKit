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
    
    @Published public var isAudioPlaying = false
    @Published public var isMuted = false
    
    @Published public var appleMusic = AppleMusicController()
    @Published public var spotify = SpotifyController()
    @Published public var volume = VolumeController()
        
    public init() {}
}

extension SystemController: PlaybackController {
    
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
