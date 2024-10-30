//
//  PlaybackController.swift
//  ControlKit
//

/// Describes an object that controls media/audio playback.
@MainActor
protocol PlaybackController {
    
    func togglePlayPause()
    func skipToNextTrack()
    func skipToPreviousTrack()
}
