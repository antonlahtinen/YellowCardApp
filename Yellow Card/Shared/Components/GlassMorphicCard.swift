//
//  GlassMorphicCard.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import SwiftUI

/// A reusable view modifier that applies a glassmorphic card style
/// with a frosted glass effect, subtle border and shadow
struct GlassMorphicCard<Content: View>: View {
    /// The content view to be displayed inside the card
    let content: Content

    /// Initializes the card with the given content
    /// - Parameter content: A closure that returns the content view
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            // Apply frosted glass material effect
            .background(.ultraThinMaterial)
            // Add subtle white overlay for depth
            .background(Color.white.opacity(0.05))
            // Round the corners
            .cornerRadius(20)
            // Add thin border for definition
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            // Add subtle shadow for elevation
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}
