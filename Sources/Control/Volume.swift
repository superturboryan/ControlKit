//
//  Volume.swift
//  ControlKit
//

import MediaPlayer

public extension Control {
    
    /// Control the system volume using the underlying `MPVolumeView`.
    @MainActor
    enum Volume {
        
        /// Subscribe to `volume` via ``VolumeController.volume`` `@Published` property.
        public static var volume: Float {
            get { MPVolumeView.volume }
            set { MPVolumeView.volume = newValue }
        }
        
        /// Subscribe to `isMuted` via ``VolumeController.isMuted`` `@Published` property.
        static var isMuted = false
        
        private static var mutedValue: Float = 0
        
        public static func increaseVolume(_ amount: Float = 0.1) {
            volume += amount
        }
        
        public static func decreaseVolume(_ amount: Float = 0.1) {
            volume -= amount
        }
        
        public static func toggleMute() {
            if !isMuted {
                mutedValue = volume
            }
            isMuted.toggle()
            volume = isMuted ? 0 : mutedValue
        }
    }
}
