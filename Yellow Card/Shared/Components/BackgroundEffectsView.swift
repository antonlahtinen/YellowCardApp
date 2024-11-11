//
//  BackgroundEffectsView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import SwiftUI

/// A view that creates a blurred gradient background effect using overlapping circles
struct BackgroundEffectsView: View {
    var body: some View {
        GeometryReader { geometry in
            // Stack circles on top of each other
            ZStack {
                let baseSize = max(geometry.size.width, geometry.size.height)
                // Create 3 circles with different sizes and offsets
                ForEach(0..<3) { index in
                    Circle()
                        // Apply gradient fill from blue to purple with transparency
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        // Increase size for each subsequent circle
                        .frame(width: baseSize * (0.4 + CGFloat(index) * 0.2))
                        // Offset each circle diagonally
                        .offset(
                            x: geometry.size.width * (CGFloat(index) * 0.1 - 0.2),
                            y: geometry.size.height * (CGFloat(index) * 0.1 - 0.2)
                        )
                        // Apply increasing blur effect for depth
                        .blur(radius: baseSize * 0.02 * CGFloat(index + 1))
                }
            }
        }
    }
}

