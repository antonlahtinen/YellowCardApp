//
//  HapticFeedback.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import UIKit
import SwiftUI

/// Plays haptic feedback with the specified style
/// - Parameter style: The UIImpactFeedbackGenerator style to use (light, medium, heavy, soft, rigid)
    func playHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    // Create feedback generator with specified style
    let generator = UIImpactFeedbackGenerator(style: style)
    // Trigger the haptic feedback
    generator.impactOccurred()
}
