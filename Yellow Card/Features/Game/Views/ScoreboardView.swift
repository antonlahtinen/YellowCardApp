import SwiftUI

/// A view that displays the game scoreboard with team scores, half number, and time
struct ScoreboardView: View {
    /// The game state containing all the match information
    @ObservedObject var gameState: GameState
    /// Controls the animation state of the scoreboard elements
    @State private var isAnimating = false

    /// Colors used for the background gradient
    private let gradientColors = [
        Color(red: 0.1, green: 0.2, blue: 0.45),
        Color(red: 0.1, green: 0.1, blue: 0.2)
    ]

    /// Formats the current game time as MM:SS string
    var formattedTime: String {
        let minutes = gameState.currentHalfState.time / 60
        let seconds = gameState.currentHalfState.time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Main scoreboard
            ScoreboardPanel {
                HStack(spacing: 20) {
                    // Home team score
                    TeamScore(
                        team: gameState.homeTeam,
                        score: gameState.homeScore,
                        alignment: .leading
                    )
                    .frame(maxWidth: .infinity)

                    // VS separator
                    Text("VS")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))

                    // Away team score
                    TeamScore(
                        team: gameState.awayTeam,
                        score: gameState.awayScore,
                        alignment: .trailing
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .offset(y: isAnimating ? 0 : -30)
            .opacity(isAnimating ? 1 : 0)

            // Time panel
            ScoreboardPanel(height: 50) {
                HStack(spacing: 16) {
                    TimeIndicator(label: "HALF", value: "\(gameState.half)")
                        .frame(maxWidth: .infinity)

                    Divider()
                        .frame(height: 20)
                        .background(Color.white.opacity(0.3))

                    TimeIndicator(label: "TIME", value: formattedTime)
                        .frame(maxWidth: .infinity)

                    if gameState.currentHalfState.stoppageTime > 0 {
                        Divider()
                            .frame(height: 20)
                            .background(Color.white.opacity(0.3))

                        TimeIndicator(
                            label: "STOPPAGE",
                            value: "+\(gameState.currentHalfState.stoppageTime)'",
                            valueColor: .yellow
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            }
            .offset(y: isAnimating ? 0 : 30)
            .opacity(isAnimating ? 1 : 0)
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
        .padding(.top, 44)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

/// A container view that provides a consistent style for scoreboard panels
struct ScoreboardPanel<Content: View>: View {
    /// The height of the panel
    var height: CGFloat = 80
    /// The content to display within the panel
    let content: Content

    init(height: CGFloat = 80, @ViewBuilder content: () -> Content) {
        self.height = height
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                // Semi-transparent background with border
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
    }
}

/// A view that displays a labeled time-related value
struct TimeIndicator: View {
    /// The label text shown above the value
    let label: String
    /// The value to display
    let value: String
    /// The color of the value text (defaults to white)
    var valueColor: Color = .white

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))

            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(valueColor)
        }
    }
}
