//
//  SPTAppRemote.swift
//  ControlKit
//

import OSLog
import SpotifyiOS

extension SPTAppRemote {
    
    func togglePlayPause() {
        playerAPI?.getPlayerState { [weak self] result, error in
            guard
                let self,
                error == nil,
                let state = result as? SPTAppRemotePlayerState
            else {
                Logger(subsystem: Controllers.subsystem, category: "SPTAppRemote_Extension")
                    .error("Failed to get player state with error: \(error?.localizedDescription ?? "🤷‍♂️")")
                return
            }
            if state.isPaused {
                playerAPI?.resume(nil)
            } else {
                playerAPI?.pause(nil)
            }
        }
    }
}
