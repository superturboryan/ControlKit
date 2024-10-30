![ControlKit Light](https://github.com/user-attachments/assets/11ad00d7-a200-46bc-bc99-4b214131dfe7#gh-light-mode-only)
![ControlKit Dark](https://github.com/user-attachments/assets/b0d1fa79-4b56-4fd1-bb5b-4a25c9e3254c#gh-dark-mode-only)

# ControlKit

**ControlKit** is a minimal Swift Package enabling control of media playback and system volume.  

![Minimum iOS Version](https://img.shields.io/badge/%F0%9F%93%B1%20iOS-15%2B-blue.svg) ![Build Status](https://github.com/superturboryan/ControlKit/workflows/%F0%9F%A7%A9%20Build%20Package/badge.svg) ![Lint](https://github.com/superturboryan/ControlKit/workflows/%F0%9F%A7%B9%20Lint/badge.svg) ![Contributors](https://img.shields.io/github/contributors/superturboryan/ci-playground)

### TLDR 

Control the device's volume with one line:  

```swift
Control.Volume.increase() // 🔊 🆙
```

## Installation

Add ControlKit as a dependency in your Xcode project:

1. Go to **File > Add Package Dependencies…**  

2. Enter the package URL in the search bar:  

```
https://github.com/superturboryan/ControlKit.git
```  

3. Choose the libraries you want to include:  
  
![Screenshot 2024-10-28 at 17 46 50](https://github.com/user-attachments/assets/48e0a678-fd75-4056-9754-867a11b87d67)

## Requirements

[`SpotifyController`](Sources/Controllers/SpotifyController.swift) requires a Spotify _Client ID_ 
and _Redirect URL_ to authorize with & control the Spotify app.  

1. [Define a custom URL scheme for your app](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app). 
Add a `URL Type` to the target's `Info.plist`.

2. Create an app in the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard) 
to get a _client ID_ and register your _redirect URL_ (scheme).

<img width="1007" alt="Screenshot 2024-10-29 at 17 31 24" src="https://github.com/user-attachments/assets/895c8092-4a9d-4526-9f85-5da7b868fbc1">

### Warning 👇

The Spotify access token is **not persisted across app launches** by default. 

You must provide an object conforming to **`DAO<String>`** if you want the access token to be persisted.

## Usage

### Control

```swift
import Control

// 🔊 Decrement system volume
Control.Volume.decreaseVolume()

// 🕵️‍♂️ Check if audio is being played (by another app)
if Control.Playback.isAudioPlaying { 
    // 💃🕺 
}

// ⏭️ Skip to next track (Apple Music only - use Controllers.SpotifyController for Spotify 💚)
Control.Playback.AppleMusic.skipToNextTrack()

// 🫨 Vibrate
Control.Haptics.vibrate()
```

### Controllers

```swift
// App.swift

import Controllers
import SwiftUI

@main struct YourApp: App {

    @StateObject var spotify = SpotifyController(
        config: .init(
            clientID: Secrets.clientID,
            redirectURL: "controlkit://spotify"
        )
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(spotify)
            .onOpenURL { spotify.setAccessToken(from: $0) } // Parse access token from URL
        }
    }
    
    func skipToNextSpotifyTrack() {
        spotify.skipToNextTrack()
    }
}

// Secrets.swift 🔐
// Don't forget to gitignore this 🙈

enum Secrets {
    static let clientID = "<your client id>"
}
```

## Dependencies

📚 [AVFAudio](https://developer.apple.com/documentation/avfaudio)  
📚 [Media Player](https://developer.apple.com/documentation/mediaplayer/)    
📦 [SpotifyiOS](https://github.com/spotify/ios-sdk)  

## Contributing

Contributions and feedback are welcome! 🧑‍💻👩‍💻  

Here are a few guidelines:

- You can [open an Issue](https://github.com/superturboryan/ControlKit/issues/new) or raise a PR 🤝
- Commit messages should contain emojis ❤️ and be [signed](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits) 🔏
- [Workflows](https://github.com/superturboryan/ControlKit/actions) should be green 🟢
- `main` should be [linear](https://stackoverflow.com/questions/20348629/what-are-the-advantages-of-keeping-linear-history-in-git) 🎋 
