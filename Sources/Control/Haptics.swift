//
//  Haptics.swift
//  ControlKit
//

import UIKit

public extension Control {
    
    /// 🫨 Control device haptics.
    @MainActor
    enum Haptics {
        
        /// This function uses `UIImpactFeedbackGenerator/impactOccurred` to create a soft vibration,
        /// which can be used to provide tactile feedback in response to user interactions.
        public static func vibrate() {
            UIImpactFeedbackGenerator().impactOccurred()
        }
    }
}
