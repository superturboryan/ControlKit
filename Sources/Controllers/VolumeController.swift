//
//  VolumeController.swift
//  ControlKit
//

import Control
import SwiftUI

/// Wrapper for ``Control.Volume``
@MainActor
public final class VolumeController: ObservableObject {
    
    @Published public var volume: Float = Control.Volume.volume
    @Published public var isMuted = false
    
    public init() {
        updateVolume()
    }
    
    public func increaseVolume(_ amount: Float = 0.1) {
        Control.Volume.increaseVolume(amount)
        updateVolume()
    }
    
    public func decreaseVolume(_ amount: Float = 0.1) {
        Control.Volume.decreaseVolume(amount)
        updateVolume()
    }
    
    public func toggleMute() {
        isMuted.toggle()
        Control.Volume.toggleMute()
        updateVolume()
    }
}

private extension VolumeController {
    
    func updateVolume() {
        volume = Control.Volume.volume
    }
}
