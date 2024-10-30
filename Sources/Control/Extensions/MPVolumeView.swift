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
        guard volume < 1 else {
            print("🚨 Volume is already at max")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            volume += amount
        }
    }
    
    static func decreaseVolume(_ amount: Float) {
        guard volume > 0 else {
            print("🚨 Volume is already at min")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            volume -= amount
        }
    }
}

private extension MPVolumeView {
    
    static let shared = MPVolumeView()
    
    var slider: UISlider? {
        subviews.first(where: { $0 is UISlider }) as? UISlider
    }
}
