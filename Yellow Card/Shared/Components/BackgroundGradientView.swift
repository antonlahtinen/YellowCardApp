//
//  BackgroindGradientView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import SwiftUI

/// A view that creates a gradient background effect between two colors
struct BackgroundGradientView: View {
    /// The starting color of the gradient
    let start: Color
    /// The ending color of the gradient
    let end: Color

    var body: some View {
        // Create a linear gradient from top-left to bottom-right
        LinearGradient(gradient: Gradient(colors: [start, end]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea() // Ensures the gradient fills the entire screen
    }
}
