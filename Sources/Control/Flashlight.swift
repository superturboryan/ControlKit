//
//  Flashlight.swift
//  ControlKit
//

import AVFoundation
import OSLog

extension Control {
    
    /// 🔦 Control the device's flashlight.
    public enum Flashlight {}
}

extension Control.Flashlight {
    
    /// Indicates whether the device's flashlight is currently turned on.
    ///
    /// - Returns: A Boolean value indicating the flashlight state. Returns `true` if the flashlight is on, otherwise `false`.
    public static var isOn: Bool {
        (deviceWithFlashlight?.torchLevel ?? 0) > 0
    }
    
    /// Toggles the device's flashlight on/off.
    ///
    /// - Parameter isOn: A Boolean value to specify the desired state of the flashlight.
    /// Pass `true` to turn it on or `false` to turn it off.
    ///                   If no value is provided, the flashlight toggles its current state.
    /// - Important: The flashlight can only be used while the app is in the foreground.
    /// If the flashlight is on and the app is backgrounded, the flashlight will turn off.
    /// - Note: If the device does not have a flashlight, this method does nothing.
    public static func toggle( _ isOn: Bool = !isOn) {
        guard let deviceWithFlashlight else {
            return
        }
        do {
            try deviceWithFlashlight.lockForConfiguration()
            if isOn {
                try deviceWithFlashlight.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            } else {
                deviceWithFlashlight.torchMode = .off
            }
            deviceWithFlashlight.unlockForConfiguration()
        } catch {
            log.error("Error toggling flashlight: \(error.localizedDescription) to \(isOn ? "on" : "off")")
        }
    }
    
    private static var deviceWithFlashlight: AVCaptureDevice? {
        guard
            let device = AVCaptureDevice.default(for: .video),
            device.hasTorch
        else {
            #if targetEnvironment(simulator)
            log.info("Simulator does not have a flashlight (yet)")
            #else
            log.info("Flashlight (torch) not available")
            #endif
            return nil
        }
        return device
    }
    
    private static let log = Logger(subsystem: Control.subsystem, category: "Flashlight")
}
