import SwiftUI
import UIKit

/// A custom menu button view with an icon, title and subtitle
struct MenuButton: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        HStack(spacing: 16) {
            // Icon container with circular background
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }

            // Title and subtitle text stack
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)

                Text(subtitle)
                    .font(.subheadline)
                    .opacity(0.7)
            }
            .foregroundColor(.white)

            Spacer()

            // Right chevron icon
            Image(systemName: "chevron.right")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(20)
        .background(
            // Glassmorphic background effect
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}

/// A custom button style for football-related actions
struct FootballButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1) // Shrink when pressed
            .onTapGesture {
                playHapticFeedback(style: .medium)
            }
    }
}

/// A custom button style for score increment/decrement buttons
struct ScoreButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24, weight: .bold))
            .frame(width: 44, height: 44)
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(22)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1) // Shrink when pressed
            .onTapGesture {
                playHapticFeedback(style: .soft)
            }
    }
}

/// A custom button style for stoppage time controls
struct StoppageTimeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .bold))
            .frame(width: 36, height: 36)
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(18)
            .scaleEffect(configuration.isPressed ? 0.95 : 1) // Shrink when pressed
            .onTapGesture {
                playHapticFeedback(style: .rigid)
            }
    }
}

/// A custom button style for main menu buttons
struct MainMenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1) // Shrink when pressed
            .onTapGesture {
                playHapticFeedback(style: .medium)
            }
    }
}

/// A reusable control button with customizable icon, label and size
struct ControlButton: View {
    var label: String? = nil
    var icon: String? = nil
    var size: CGFloat = 24  // Default size
    var width: CGFloat? = nil
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
            playHapticFeedback(style: .soft)
        }) {
            HStack(spacing: 8) {
                // Optional icon
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: size))
                }
                // Optional text label
                if let label = label {
                    Text(label)
                        .font(.system(size: size, weight: .medium))
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(width: width, height: size + 16)
            .background(
                Capsule()
                    .fill(Color.gray.opacity(0.7))
            )
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Extension to provide size presets for ControlButton
extension ControlButton {

    /// Defines standard sizes for the control button
    enum Size {
        case small
        case medium
        case large
        case custom(iconSize: CGFloat, textSize: CGFloat, height: CGFloat)

        /// Returns the icon size for the selected preset
        var iconSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 20
            case .large: return 26
            case .custom(let iconSize, _, _): return iconSize
            }
        }

        /// Returns the text size for the selected preset
        var textSize: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 22
            case .large: return 24
            case .custom(_, let textSize, _): return textSize
            }
        }

        /// Returns the height for the selected preset
        var height: CGFloat {
            switch self {
            case .small: return 52
            case .medium: return 60
            case .large: return 68
            case .custom(_, _, let height): return height
            }
        }
    }

    /// Convenience initializer that accepts a Size preset
    init(label: String? = nil, icon: String? = nil, size: Size = .medium, width: CGFloat? = nil, action: @escaping () -> Void) {
        self.label = label
        self.icon = icon
        self.size = size.iconSize
        self.width = width
        self.action = action
    }
}
