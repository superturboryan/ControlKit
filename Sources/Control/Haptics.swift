//
//  Haptics.swift
//  ControlKit
//

import UIKit

public extension Control {
    
    @MainActor
    enum Haptics {
        
        public static func vibrate() {
            UIImpactFeedbackGenerator().impactOccurred()
        }
    }
}
