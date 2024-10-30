//
//  Volume.swift
//  ControlKit
//

import MediaPlayer

public extension Control {
    
    /// Control the system volume using the underlying `MPVolumeView`.
    @MainActor
    enum Volume {
        
        /// Subscribe to `volume` via ``VolumeController/volume`` `@Published` property.
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
        
        /// Subscribe to `isMuted` via ``VolumeController/isMuted`` `@Published` property.
        public static var isMuted = false {
            didSet {
                if isMuted {
                    Helpers.mutedVolumeLevel = volume
                }
                volume = isMuted ? 0 : Helpers.mutedVolumeLevel
            }
        }
        
        /// Increments the system volume, mimicking when a user taps the volume rocker on their phone.
        ///
        /// - Parameter amount: clamped between 0 and 1.0 using ``BetweenZeroAndOneInclusive``.
        ///
        /// - Important: Calling this function will _unmute_ the system volume. The increment amount is
        /// applied to the volume level prior to it being muted.
        public static func increase(
            @BetweenZeroAndOneInclusive _ amount: Float = Helpers.defaultVolumeStep
        ) {
            volume += amount
        }
        
        /// Decrements the system volume, mimicking when a user taps the volume rocker on their phone.
        ///
        /// - Parameter amount: clamped between 0 and 1.0 using ``BetweenZeroAndOneInclusive``.
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
        static var mutedVolumeLevel: Float = 0
        
        /// Refers to the number of (volume rocker) button presses it takes for the phone's volume to go from 0 to max.
        private static let maxVolumeButtonPresses: Float = 16
    }
}
