//
//  SpotifyController.swift
//  ControlKit
//

import OSLog
import SpotifyiOS
import SwiftUI

/// Wrapper for ``SPTAppRemote`` - use this to control playback from the Spotify app.
public final class SpotifyController: NSObject, ObservableObject {
    
    @Published public var isPlaying: Bool = false
    
    lazy private var remote: SPTAppRemote = {
        let remote = SPTAppRemote(
            configuration: SPTConfiguration(
                clientID: SpotifyConfig.clientID,
                redirectURL: URL(string: SpotifyConfig.redirectURL)!
            ),
            logLevel: .debug
        )
        remote.connectionParameters.accessToken = accessToken
        remote.delegate = self
        remote.playerAPI?.delegate = self
        return remote
    }()
    
    @AppStorage("SpotifyAccessToken")
    private var accessToken: String?
    
    override public init() {
        super.init()
        connect()
    }
    
    /// Deep links to the Spotify app where the authorization flow is completed before reopening the host app.
    public func authorize() {
        self.remote.authorizeAndPlayURI("")
    }
    
    /// Use this inside a SwiftUI onOpenURL modifier to parse and save the access token from the URL callback.
    /// ```
    /// .onOpenURL { systemController.spotify.setAccessToken(from: $0) }
    /// ```
    public func setAccessToken(from url: URL) {
        guard
            let parameters = remote.authorizationParameters(from: url),
            let newToken = parameters[SPTAppRemoteAccessTokenKey]
        else {
            return
        }
        self.accessToken = newToken
        remote.connectionParameters.accessToken = newToken
        connect()
    }
    
    /// Creates a connection (subscription) to the Spotify app.
    public func connect() {
        guard remote.connectionParameters.accessToken != nil else {
            return
        }
        remote.connect()
    }
    
    /// Disconnect from the Spotify app. Call this when your app is terminating (scene == .inactive).
    public func disconnect() {
        guard remote.isConnected else {
            return
        }
        remote.disconnect()
    }
}

extension SpotifyController: PlaybackController {
    
    public func togglePlayPause() {
        remote.togglePlayPause()
    }
    
    public func skipToNextTrack() {
        remote.playerAPI?.skip(toNext: nil)
    }
    
    public func skipToPreviousTrack() {
        remote.playerAPI?.skip(toPrevious: nil)
    }
}

extension SpotifyController: SPTAppRemoteDelegate {
    
    public func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        SpotifyController.log.info("SPTAppRemoteDelegate.appRemoteDidEstablishConnection")
    }
    
    public func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: (any Error)?) {
        SpotifyController.log.info("SPTAppRemoteDelegate.didFailConnectionAttemptWithError")
    }
    
    public func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: (any Error)?) {
        SpotifyController.log.info("SPTAppRemoteDelegate.didDisconnectWithError")
    }
}

extension SpotifyController: SPTAppRemotePlayerStateDelegate {
    
    public func playerStateDidChange(_ playerState: any SPTAppRemotePlayerState) {
        isPlaying = !playerState.isPaused
    }
}

private extension SpotifyController {
    
    static let log = Logger(subsystem: Controllers.subsystem, category: "SpotifyController")
}

private extension SPTAppRemote {
    
    func togglePlayPause() {
        playerAPI?.getPlayerState { [weak self] result, error in
            guard
                let self,
                error == nil,
                let state = result as? SPTAppRemotePlayerState
            else {
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
