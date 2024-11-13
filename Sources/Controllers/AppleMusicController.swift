//
//  AppleMusicController.swift
//  ControlKit
//

import Control
import SwiftUI

/// 🍎 Manage playback from the **Apple Music** app and subscribe to its playback state.
///
/// This class provides an interface to control media playback in the Apple Music app and allows you to subscribe to
/// the playback state. It leverages the `Control/Playback/AppleMusic`  to perform actions such as toggling the playback state
/// and monitoring playback status.
public final class AppleMusicController: ObservableObject, PlaybackController {
    
    @Published public private(set) var isPlaying: Bool = Control.Playback.AppleMusic.isPlaying
    
    public init() {}
    
    /// Toggles playback and updates the ``isPlaying`` **`@Published`** property.
    public func togglePlayPause() {
        Control.Playback.AppleMusic.togglePlayPause()
        updateIsPlaying()
    }
    
    /// Sends the "next track command" to the **Apple Music** app.
    public func skipToNextTrack() {
        Control.Playback.AppleMusic.skipToNextTrack()
    }
    
    /// Sends the "previous track command" to the **Apple Music** app.
    public func skipToPreviousTrack() {
        Control.Playback.AppleMusic.skipToPreviousTrack()
    }
}

private extension AppleMusicController {
    
    func updateIsPlaying() {
        isPlaying = Control.Playback.AppleMusic.isPlaying
    }
}
