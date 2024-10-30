![Group 1](https://github.com/user-attachments/assets/1cefe10d-0b3c-45be-a7e9-443603704ca7)

**ControlKit** is a lightweight Swift Package enabling control of media playback and system volume for third-party 
apps.

## Installation

To install **ControlKit**, add it as a dependency to your Xcode project by going to  
`File > Add Package Dependencies...`  

Enter the package URL (https://github.com/superturboryan/ControlKit.git) in the search bar:  
  
![Screenshot 2024-10-28 at 17 54 24](https://github.com/user-attachments/assets/4261f2ee-bbde-49c1-a911-f2a3217db586)

This package contrains two libraries: **Control** + **Controllers**.    
When prompted, select the libraries you want to add to your project's targets:  
      
![Screenshot 2024-10-28 at 17 46 50](https://github.com/user-attachments/assets/48e0a678-fd75-4056-9754-867a11b87d67)

## Requirements

ControlKit requires a **Spotify Client ID and Redirect URL** for [`SpotifyController`](https://github.com/superturboryan/ControlKit/blob/main/Sources/Controllers/SpotifyController.swift) to work.   

You'll need to **create an app** in the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
in order to get a _client ID_ and register your _redirect URL_.  

Define the values for your Spotify app somewhere in the project:  
  
```swift
enum SpotifyConfig {
    static let clientID = "<your spotify app client id goes here>"
    static let redirectURL = "controlkit://spotify"
}
```

You'll also need to [define a custom URL scheme for your app](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app)
so that Spotify is able to reopen your app after completing the authorization flow. Add a `URL Type` to the target's `Info.plist`:  

<img width="1007" alt="Screenshot 2024-10-29 at 17 31 24" src="https://github.com/user-attachments/assets/895c8092-4a9d-4526-9f85-5da7b868fbc1">

## Usage

### Control

```swift
import Control

// 🔊 Increment system volume
Control.Volume.increaseVolume()

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

    @StateObject var spotify = SpotifyController()
    
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
```

## Dependencies

📚 [AVFAudio](https://developer.apple.com/documentation/avfaudio)  
📚 [Media Player](https://developer.apple.com/documentation/mediaplayer/)    
📦 [SpotifyiOS](https://github.com/spotify/ios-sdk)  

## Contributing

Contributions and feedback are welcome! 🤝  

You can open an Issue or raise a PR.

Emojis required in all commit messages ❤️
