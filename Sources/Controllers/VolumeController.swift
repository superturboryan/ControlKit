//
//  VolumeController.swift
//  ControlKit
//

import Control
import SwiftUI

/// Wrapper for ``Control/Volume`` - use this to control and subscribe to the system volume, mimicking when the phone's volume rocker is pressed.
@MainActor
public final class VolumeController: ObservableObject {
    
    @Published public var volume: Float = Control.Volume.volume
    @Published public private(set) var isMuted = Control.Volume.isMuted
    
    public init() {}
    
    public func increaseVolume(_ amount: Float = 0.1) {
        Control.Volume.increaseVolume(amount)
        volumeChanged()
    }
    
    public func decreaseVolume(_ amount: Float = 0.1) {
        Control.Volume.decreaseVolume(amount)
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
