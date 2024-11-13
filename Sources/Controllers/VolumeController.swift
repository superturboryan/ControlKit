//
//  VolumeController.swift
//  ControlKit
//

import Control
import SwiftUI

/// 🎚️ Manage device volume and muted state.
///
/// `VolumeController` provides functionality to control the audio volume and mute state of the device.
///
@MainActor
public final class VolumeController: ObservableObject {
    
    /// The device's current volume level.
    ///
    /// This property tracks the device’s current volume, ranging from 0 (muted) to 1 (maximum volume).
    @Published public private(set) var volume: Float = Control.Volume.volume
    
    /// Indicates whether the device's audio output is muted.
    ///
    /// This property tracks the mute state of the system. When `true`, the system's volume is effectively set to 0.
    @Published public private(set) var isMuted = Control.Volume.isMuted
    
    public init() {}
    
    /// Increments the device's volume using `Control/Volume/increase` and updates
    /// the ``volume`` and ``isMuted`` **`@Published`** properties.
    public func increaseVolume(_ amount: Float = 0.1) {
        Control.Volume.increase(amount)
        volumeChanged()
    }
    
    /// Decrements the device's volume using `Control/Volume/decrease` and updates
    /// the ``volume`` and ``isMuted`` **`@Published`** properties.
    public func decreaseVolume(_ amount: Float = 0.1) {
        Control.Volume.decrease(amount)
        volumeChanged()
    }
    
    /// Toggles the device's volume  by toggling `Control/Volume/isMuted` and updates
    /// the ``volume`` and ``isMuted`` **`@Published`** properties.
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
