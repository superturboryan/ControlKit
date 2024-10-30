//
//  SpotifyController.swift
//  ControlKit
//

import OSLog
import SpotifyiOS
import SwiftUI

/// Wrapper for ``SPTAppRemote``  - use this to control playback and subscribe to the playback state of the Spotify app.
///
/// `SpotifyController` facilitates the connection to and interaction with the Spotify app, enabling playback control and handling the authorization flow.
///
public final class SpotifyController: NSObject, ObservableObject {
    
    @Published public private(set) var isPlaying: Bool = false
    
    private lazy var remote: SPTAppRemote = {
        let remote = SPTAppRemote(
            configuration: SPTConfiguration(
                clientID: config.clientID,
                redirectURL: config.redirectURL
            ),
            logLevel: config.logLevel
        )
        do {
            remote.connectionParameters.accessToken = try accessTokenDAO?.get()
        } catch {
            Self.log.debug("Access token not set: \(error.localizedDescription)")
        }
        remote.delegate = self
        remote.playerAPI?.delegate = self
        return remote
    }()
    
    private let config: SpotifyConfig
    private let accessTokenDAO: (any DAO<String>)?
    
    /// The main initializer for `SpotifyController`.
    ///
    /// - Parameters:
    ///   - config: The `SpotifyConfig` object used to configure the controller.
    ///   If `config` is `.empty`, the controller will not attempt to connect automatically.
    ///   The default log level is **`SPTAppRemoteLogLevel.debug`**.
    ///   - accessTokenDAO: An object conforming to `DAO<String>` that persists the Spotify access token. By default, this optional parameter
    ///   is nil and the access token is not persisted across app launches.
    ///   - autoConnect: A Boolean value that determines whether the controller should attempt to connect to Spotify automatically upon initialization.
    ///   The default value is `true`. If `true` and `config` is not `.empty`, the controller will initiate the connection.
    ///
    /// - Warning: Saving the Spotify access token (_or any other sensitive informative)_ using **``UserDefaults``** is not recommended for production apps.
    ///   Prefer providing a `DAO` that persists values to the Keychain 🔐
    ///
    public init(
        config: SpotifyConfig,
        accessTokenDAO: (any DAO<String>)? = nil,
        autoConnect: Bool = true
    ) {
        self.config = config
        self.accessTokenDAO = accessTokenDAO
        super.init()
        if autoConnect && config != .empty {
            connect()
        }
    }
    
    /// Deep links to the Spotify app where the authorization flow is completed before reopening the host app.
    ///
    /// Use `setAccessToken(from url:)` in a SwiftUI `View.onOpenURL(perform:)` modifier to parse and persist the access token.
    /// This will be called when the Spotify app completes the authorization flow as it uses the `redirectURL` provided in the configuration
    /// to deep link back to the app that initiated the authorization flow.
    public func authorize() {
        // Using an empty string here will attempt to play the user's last song
        self.remote.authorizeAndPlayURI("")
    }
    
    /// Parses the provided URL to extract and assign the access token, optionally persisting it across app launches.
    ///
    /// This method does three things:
    /// - Parses the provided URL
    /// - Assigns the access token (if found) to the local `SPTAppRemote.connectionParameters.accessToken`
    /// - Attempts to persist the access token using the optional `DAO<String>` property.
    ///
    /// Use this inside a SwiftUI onOpenURL modifier to parse and save the access token from the URL callback.
    /// ```
    /// .onOpenURL { systemController.spotify.setAccessToken(from: $0) }
    /// ```
    /// - Important: The access token will **not be persisted** across app launches if an `accessTokenDAO` parameter
    /// is not provided when initializing `SpotifyController`.
    public func setAccessToken(from url: URL) {
        guard
            let parameters = remote.authorizationParameters(from: url),
            let newToken = parameters[SPTAppRemoteAccessTokenKey]
        else {
            Self.log.error("Failed to parse access token from URL: \(url, privacy: .private)")
            return
        }
        do {
            try accessTokenDAO?.save(newToken)
        } catch {
            Self.log.warning("Failed to persist access token: \(error.localizedDescription)")
        }
        remote.connectionParameters.accessToken = newToken
    }
    
    /// Creates a connection (subscription) to the Spotify app.
    public func connect() {
        guard remote.connectionParameters.accessToken != nil else {
            Self.log.warning("Attempting to connect to Spotify without first setting access token")
            return
        }
        remote.connect()
    }
    
    /// Disconnect from the Spotify app.
    ///
    /// Call this when your app is terminating (scene == .inactive).
    public func disconnect() {
        guard remote.isConnected else {
            Self.log.warning("Attempting to disconnect from Spotify app but remote is not connected")
            return
        }
        remote.disconnect()
        do {
            try accessTokenDAO?.delete()
        } catch {
            Self.log.warning("Failed to delete access token: \(error.localizedDescription)")
        }
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

extension SpotifyController {
    
    public struct SpotifyConfig: Equatable {
        
        let clientID: String
        let logLevel: SPTAppRemoteLogLevel
        let redirectURL: URL
        
        public init(
            clientID: String,
            logLevel: SPTAppRemoteLogLevel = .info,
            redirectURL: String
        ) {
            self.clientID = clientID
            self.logLevel = logLevel
            self.redirectURL = URL(string: redirectURL)!
        }
        
        public static var empty: Self {
            .init(clientID: "123", redirectURL: "456")
        }
    }
    
    private static let log = Logger(subsystem: Controllers.subsystem, category: "SpotifyController")
}

private extension SPTAppRemote {
    
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
