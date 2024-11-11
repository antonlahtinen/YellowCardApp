//
//  FootballField.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 3.11.2024.
//

// MARK: - Football Field Components

import SwiftUI

/// A view that renders a football/soccer field with realistic grass texture and field markings
struct FootballField: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base gradient with glass effect to create realistic grass appearance
                LinearGradient(
                    stops: [
                        .init(color: Color.grassLight.opacity(0.8), location: 0.0),
                        .init(color: Color.grassDark.opacity(0.8), location: 0.5),
                        .init(color: Color.grassLight.opacity(0.8), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .background(.ultraThinMaterial)

                // Field elements including lines, markings and penalty areas
                FieldContent(geometry: geometry)
                    .overlay(
                        // Adds a subtle radial highlight in the center of the field
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.0)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: geometry.size.height * 0.8
                        )
                    )
            }
        }
        .modifier(FieldAnimation()) // Adds subtle animation effect
    }
}

/// Contains all the visual elements that make up the football field
struct FieldContent: View {
    let geometry: GeometryProxy

    var body: some View {
        ZStack {
            // Creates alternating vertical stripes for grass texture effect
            HStack(spacing: 0) {
                ForEach(0..<20) { index in
                    Rectangle()
                        .fill(Color.white.opacity(index % 2 == 0 ? 0.05 : 0.0))
                        .frame(width: geometry.size.width / 20)
                }
            }

            // Field markings with consistent styling for lines and areas
            Group {
                // Outer boundary rectangle
                FieldMarkings()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: geometry.size.width * 0.9,
                           height: geometry.size.height * 0.9)

                // Center circle
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: min(geometry.size.width, geometry.size.height) * 0.2)

                // Halfway line
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: geometry.size.width * 0.9, height: 2)

                // Top penalty area with goal box
                PenaltyArea(position: .top)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: geometry.size.width * 0.8,
                           height: geometry.size.height * 0.2)
                    .position(x: geometry.size.width * 0.5,
                             y: geometry.size.height * 0.15)

                // Bottom penalty area with goal box
                PenaltyArea(position: .bottom)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: geometry.size.width * 0.8,
                           height: geometry.size.height * 0.2)
                    .position(x: geometry.size.width * 0.5,
                             y: geometry.size.height * 0.85)
            }
        }
    }
}

// MARK: - Supporting Types

/// Defines the outer boundary rectangle of the field
struct FieldMarkings: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addRect(rect)
        }
    }
}

/// Defines the penalty area and goal box shapes
struct PenaltyArea: Shape {
    /// Indicates whether the penalty area is at the top or bottom of the field
    enum Position {
        case top
        case bottom
    }

    var position: Position

    func path(in rect: CGRect) -> Path {
        Path { path in
            // Draw the main penalty area rectangle
            path.addRect(rect)

            // Calculate dimensions for the inner goal area
            let goalAreaWidth = rect.width * 0.6
            let goalAreaHeight = rect.height * 0.5
            let goalAreaX = (rect.width - goalAreaWidth) / 2
            let goalAreaY = position == .top ? 0 : rect.height - goalAreaHeight

            // Draw the goal area rectangle
            path.addRect(CGRect(
                x: goalAreaX,
                y: goalAreaY,
                width: goalAreaWidth,
                height: goalAreaHeight
            ))
        }
    }
}

// MARK: - Styling

/// Custom colors for the grass gradient effect
extension Color {
    /// Lighter shade of grass green
    static let grassLight = Color(red: 34/255, green: 139/255, blue: 34/255)
    /// Darker shade of grass green
    static let grassDark = Color(red: 0/255, green: 100/255, blue: 0/255)
}

/// Adds a subtle pulsing animation effect to the field
struct FieldAnimation: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .overlay(
                // Creates a subtle pulsing highlight effect
                Color.white.opacity(0.02)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .blur(radius: 10)
                    .allowsHitTesting(false)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            )
            .onAppear {
                isAnimating = true // Start the animation when view appears
            }
    }
}
