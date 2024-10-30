//
//  SystemController.swift
//  ControlKit
//

import Control
import SwiftUI

/// Controller of controllers 👑
@MainActor
public final class SystemController: ObservableObject {
    
    public enum PlaybackType { case AppleMusic, Spotify, AVAudio }
    
    @Published public var selectedPlaybackType: PlaybackType = .AVAudio
    
    @Published public var isAudioPlaying = false
    @Published public var isMuted = false
    
    @Published public var appleMusic = AppleMusicController()
    @Published public var spotify = SpotifyController()
    @Published public var volume = VolumeController()
        
    public init() {}
}

extension SystemController: @preconcurrency PlaybackController {
    
    public func togglePlayPause() {
        switch selectedPlaybackType {
            
        case .AppleMusic:
            appleMusic.togglePlayPause()
        case .Spotify:
            spotify.togglePlayPause()
        case .AVAudio:
            Control.Playback.togglePlayPause()
        }
        
        updateIsAudioPlaying()
    }
    
    public func skipToNextTrack() {
        switch selectedPlaybackType {
            
        case .AppleMusic:
            appleMusic.skipToNextTrack()
        case .Spotify:
            spotify.skipToNextTrack()
        case .AVAudio:
            appleMusic.skipToNextTrack()
            spotify.skipToNextTrack()
        }
    }
    
    public func skipToPreviousTrack() {
        switch selectedPlaybackType {
            
        case .AppleMusic:
            appleMusic.skipToPreviousTrack()
        case .Spotify:
            spotify.skipToPreviousTrack()
        case .AVAudio:
            appleMusic.skipToPreviousTrack()
            spotify.skipToPreviousTrack()
        }
    }
    
    private func updateIsAudioPlaying() {
        isAudioPlaying = Control.Playback.isAudioPlaying
    }
}

extension SystemController {
    
    public func vibrate() {
        Control.Haptics.vibrate()
    }
}
