//
//  Screen.swift
//  ControlKit
//

import UIKit

public extension Control {
    
    /// 🔆 Control the device's screen's brightness.
    @MainActor
    enum Screen {
            
        public static var isKeptAwake: Bool {
            get {
                UIApplication.shared.isIdleTimerDisabled
            }
            set {
                UIApplication.shared.isIdleTimerDisabled = newValue
            }
        }
        
        public static var brightness: CGFloat {
            get {
                UIScreen.main.brightness
            }
            set {
                UIScreen.main.brightness = min(max(newValue, 0.0), 1.0)
            }
        }
        
        public static var isDimmed: Bool {
            get {
                brightness == 0
            }
            set {
                if newValue {
                    dimScreenValue = brightness
                    brightness = 0
                } else {
                    brightness = dimScreenValue
                }
            }
        }
        
        private static var dimScreenValue: CGFloat = 0
    }
}
