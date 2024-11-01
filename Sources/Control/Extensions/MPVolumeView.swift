//
//  MPVolumeView.swift
//  ControlKit
//

import MediaPlayer

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
            print("🚨 Volume is already at max")
            return
        }
        volume = max(1, volume + amount)
    }
    
    static func decreaseVolume(_ amount: Float) {
        guard volume >= 0 else {
            print("🚨 Volume is already at min")
            return
        }
        volume = min(0, volume - amount)
    }
}

private extension MPVolumeView {
    
    static let shared = MPVolumeView()
    
    var slider: UISlider? {
        subviews.first(where: { $0 is UISlider }) as? UISlider
    }
}
