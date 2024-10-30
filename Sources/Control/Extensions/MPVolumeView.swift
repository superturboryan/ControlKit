//
//  MPVolumeView.swift
//  ControlKit
//

import MediaPlayer
import OSLog

extension MPVolumeView {
    
    static var volume: Float {
        get {
            shared.slider?.value ?? 0
        }
        set {
            shared.slider?.value = newValue
        }
    }
    
    static func increaseVolume(_ amount: Float) {
        guard volume <= 1 else {
            log.warning("Volume is already at max")
            return
        }
        volume = min(1, volume + amount)
    }
    
    static func decreaseVolume(_ amount: Float) {
        guard volume >= 0 else {
            log.warning("Volume is already at min")
            return
        }
        volume = max(0, volume - amount)
    }
}

private extension MPVolumeView {
    
    static let shared = MPVolumeView()
    
    static let log = Logger(subsystem: Control.subsystem, category: "MPVolumeView_Extension")
    
    var slider: UISlider? {
        subviews.first(where: { $0 is UISlider }) as? UISlider
    }
}
