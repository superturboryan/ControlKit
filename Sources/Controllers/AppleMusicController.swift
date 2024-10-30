//
//  AppleMusicController.swift
//  ControlKit
//

import Control
import SwiftUI

/// Wrapper for ``Control/Playback/AppleMusic`` - use this to control playback from the Apple Music app and subscribe to its state.
public final class AppleMusicController: ObservableObject, PlaybackController {
    
    @Published public private(set) var isPlaying: Bool = Control.Playback.AppleMusic.isPlaying
    
    public init() {}
    
    public func togglePlayPause() {
        Control.Playback.AppleMusic.togglePlayPause()
        updateIsPlaying()
    }
    
    public func skipToNextTrack() {
        Control.Playback.AppleMusic.skipToNextTrack()
    }
    
    public func skipToPreviousTrack() {
        Control.Playback.AppleMusic.skipToPreviousTrack()
    }
}

private extension AppleMusicController {
    
    func updateIsPlaying() {
        isPlaying = Control.Playback.AppleMusic.isPlaying
    }
}
