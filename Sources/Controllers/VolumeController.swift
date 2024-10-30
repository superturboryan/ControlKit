//
//  VolumeController.swift
//  ControlKit
//

import Control
import SwiftUI

/// A controller for managing audio volume and mute state.
///
/// `VolumeController` provides functionality to control the audio volume and mute state of the device.
///
@MainActor
public final class VolumeController: ObservableObject {
    
    @Published public private(set) var volume: Float = Control.Volume.volume
    @Published public private(set) var isMuted = Control.Volume.isMuted
    
    public init() {}
    
    public func increaseVolume(_ amount: Float = 0.1) {
        Control.Volume.increase(amount)
        volumeChanged()
    }
    
    public func decreaseVolume(_ amount: Float = 0.1) {
        Control.Volume.decrease(amount)
        volumeChanged()
    }
    
    public func toggleMute() {
        Control.Volume.isMuted.toggle()
        volumeChanged()
    }
}

private extension VolumeController {
    
    func volumeChanged() {
        volume = Control.Volume.volume
        isMuted = Control.Volume.isMuted
    }
}
