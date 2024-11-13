//
//  Volume.swift
//  ControlKit
//

import MediaPlayer

public extension Control {
    
    /// 🔊 Control the device's volume using the underlying `MediaPlayer/MPVolumeView`.
    @MainActor
    enum Volume {
        
        /// The device's current volume level.
        ///
        /// This property accesses an underlying `MediaPlayer/MPVolumeView` to read and set the volume.
        ///
        /// To monitor changes to `volume`, subscribe to the **`@Published`** property `VolumeController/volume` from `Controllers`.
        ///
        /// - Important: Updating this property will _unmute_ the system volume. The volume level prior to being muted will
        /// be ignored when setting the volume via this property.
        public static var volume: Float {
            get {
                MPVolumeView.volume
            }
            set {
                if newValue != 0 && isMuted {
                    isMuted.toggle()
                }
                MPVolumeView.volume = newValue
            }
        }
        
        /// Indicates whether the device's audio output is muted. Defaults to `false`.
        ///
        /// Setting this property to `true` mutes the device's audio output. When `isMuted` is set to `true`, the current volume level
        /// is saved to ``Helpers/mutedVolumeLevel`` before the volume is set to `0`.
        ///
        /// When `isMuted` is set back to `false`, the saved volume level is restored.
        ///
        /// To monitor changes to `isMuted`, subscribe to the **`@Published`** property `VolumeController/isMuted` in `Controllers`.
        public static var isMuted = false {
            didSet {
                if isMuted {
                    Helpers.mutedVolumeLevel = volume
                }
                volume = isMuted ? 0 : Helpers.mutedVolumeLevel
            }
        }
        
        /// Increments the device's volume, mimicking when a user taps the volume rocker on their phone.
        ///
        /// - Parameter amount: clamped between 0 and 1.0 using `BetweenZeroAndOneInclusive` property wrapper.
        /// Defaults to ``Helpers/defaultVolumeStep``.
        ///
        /// - Important: Calling this function will _unmute_ the system volume. The increment amount is
        /// applied to the volume level prior to it being muted.
        public static func increase(
            @BetweenZeroAndOneInclusive _ amount: Float = Helpers.defaultVolumeStep
        ) {
            volume += amount
        }
        
        /// Decrements the device's volume, mimicking when a user taps the volume rocker on their phone.
        ///
        /// - Parameter amount: clamped between 0 and 1.0 using `BetweenZeroAndOneInclusive` property wrapper.
        /// Defaults to ``Helpers/defaultVolumeStep``.
        ///
        /// - Important: Calling this function will _unmute_ the system volume. The decrement amount is
        /// applied to the volume level prior to it being muted.
        public static func decrease(
            @BetweenZeroAndOneInclusive _ amount: Float = Helpers.defaultVolumeStep
        ) {
            volume -= amount
        }
    }
}

extension Control.Volume {
    
    public enum Helpers {
        
        /// Refers to the amount (on scale from 0 to 1) the volume is incremented/decremented when the volume rocker is pressed on the phone.
        public static let defaultVolumeStep: Float = 1 / maxVolumeButtonPresses
        
        /// Refers to the volume level prior to it being muted.
        ///
        /// This value is updated when ``Control/Control/Volume/isMuted`` is set to `true`.
        static var mutedVolumeLevel: Float = 0
        
        /// Refers to the number of (volume rocker) button presses it takes for the phone's volume to go from 0 to max.
        private static let maxVolumeButtonPresses: Float = 16
    }
}
