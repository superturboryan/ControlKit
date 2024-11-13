//
//  MPMusicPlaybackState.swift
//  ControlKit
//

import MediaPlayer

extension MPMusicPlaybackState {
    
    var isPlaying: Bool {
        [.playing, .seekingForward, .seekingBackward].contains(self)
    }
}
