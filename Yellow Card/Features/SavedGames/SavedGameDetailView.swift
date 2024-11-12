import SwiftUI

struct SavedGameDetailView: View {
    let gameState: GameState
    @Environment(\.colorScheme) private var colorScheme
    
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dynamic background gradient
                LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]),
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                // Animated background circles
                BackgroundCirclesView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        ScoreCardView(gameState: gameState)
                        TimelineView(gameState: gameState)
                        
                        GoalsSection(
                                    goals: gameState.goals,
                                    gameState: gameState
                                )
                        
                        // Cards Section
                        CardsSection(
                            cardEvents: gameState.cardEvents,
                            gameState: gameState
                        )
                        
                        // Substitutions Section
                        SubstitutionsSection(
                            substitutions: gameState.substitutions,
                            gameState: gameState
                        )
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Match Details")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Supporting Views

struct GoalRow: View {
    let goal: GoalEvent
    let gameState: GameState
    
    
    var body: some View {
        HStack {
            Image(systemName: "soccerball")
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.team == .home ? gameState.homeTeam : gameState.awayTeam)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Text("Player #\(goal.playerNumber)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                HStack {
                    Text("\(goal.time / 60)'")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    // Half 1, 2 ET1 or ET2
                    Text(goal.half == 1 ? "- 1st Half" : goal.half == 2 ? "- 2nd Half" : goal.half == 3 ? "- ET1" : "- ET2")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                }
            }
            
            Spacer()
        }
    }
}

struct GoalsSection: View {
    let goals: [GoalEvent]
    let gameState: GameState
    
    var body: some View {
        GlassMorphicCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Goals")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if goals.isEmpty {
                    EmptyStateView(
                        icon: "soccerball",
                        message: "No goals scored"
                    )
                } else {
                    ForEach(goals.sorted(by: { $0.time < $1.time })) { goal in
                        GoalRow(goal: goal, gameState: gameState)
                        if goal.id != goals.last?.id {
                            Divider()
                                .background(Color.white.opacity(0.3))
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct ScoreCardView: View {
    let gameState: GameState
    
    var body: some View {
        GlassMorphicCard {
            VStack(spacing: 16) {
                HStack {
                    TeamScore(team: gameState.homeTeam, score: gameState.homeScore, alignment: .leading)
                    Spacer()
                    Text("VS")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                    TeamScore(team: gameState.awayTeam, score: gameState.awayScore, alignment: .trailing)
                }
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                HStack(spacing: 20) {
                    StatBox(title: "Goals", value: "\(gameState.goals.count)")
                    StatBox(title: "Cards", value: "\(gameState.cardEvents.count)")
                    StatBox(title: "Subs", value: "\(gameState.substitutions.count)")
                }
            }
            .padding()
        }
    }
}

struct TimelineView: View {
    let gameState: GameState

    var body: some View {
        GlassMorphicCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Match Timeline")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Check if extra time halves are present
                let hasExtraTime = gameState.halves[2].time > 0
                
                if hasExtraTime {
                    // More than two halves, use ScrollView
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            TimelineHalf(
                                half: "1st Half",
                                time: formatTime(gameState.halves[0].time),
                                stoppageTime: gameState.halves[0].stoppageTime
                            )
                            
                            TimelineHalf(
                                half: "2nd Half",
                                time: formatTime(gameState.halves[1].time),
                                stoppageTime: gameState.halves[1].stoppageTime
                            )
                            
                            TimelineHalf(
                                half: "ET 1",
                                time: formatTime(gameState.halves[2].time),
                                stoppageTime: gameState.halves[2].stoppageTime
                            )
                            
                            TimelineHalf(
                                half: "ET 2",
                                time: formatTime(gameState.halves[3].time),
                                stoppageTime: gameState.halves[3].stoppageTime
                            )
                        }
                    }
                } else {
                    // Only two halves, make them fill the available space
                    HStack(spacing: 20) {
                        TimelineHalf(
                            half: "1st Half",
                            time: formatTime(gameState.halves[0].time),
                            stoppageTime: gameState.halves[0].stoppageTime
                        )
                        .frame(maxWidth: .infinity)
                        .layoutPriority(1)
                        
                        TimelineHalf(
                            half: "2nd Half",
                            time: formatTime(gameState.halves[1].time),
                            stoppageTime: gameState.halves[1].stoppageTime
                        )
                        .frame(maxWidth: .infinity)
                        .layoutPriority(1)
                    }
                }
            }
            .padding()
        }
    }
}



struct CardsSection: View {
    let cardEvents: [CardEvent]
    let gameState: GameState
    
    var body: some View {
        GlassMorphicCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Card Events")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if cardEvents.isEmpty {
                    EmptyStateView(
                        icon: "rectangle.stack.badge.plus",
                        message: "No cards shown"
                    )
                } else {
                    ForEach(gameState.cardEvents.sorted(by: { $0.time < $1.time })) { event in
                        CardEventRow(event: event, gameState: gameState)
                        if event.id != gameState.cardEvents.last?.id {
                            Divider()
                                .background(Color.white.opacity(0.3))
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct SubstitutionsSection: View {
    let substitutions: [SubstitutionEvent]
    let gameState: GameState
    
    var body: some View {
        GlassMorphicCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Substitutions")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if substitutions.isEmpty {
                    EmptyStateView(
                        icon: "arrow.left.arrow.right.circle",
                        message: "No substitutions made"
                    )
                } else {
                    ForEach(substitutions.sorted(by: { $0.time < $1.time })) { substitution in
                        SubstitutionRow(substitution: substitution, gameState: gameState)
                        if substitution.id != substitutions.last?.id {
                            Divider()
                                .background(Color.white.opacity(0.3))
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Helper Views



struct TeamScore: View {
    let team: String
    let score: Int
    let alignment: HorizontalAlignment
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(team)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("\(score)")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

struct TimelineHalf: View {
    let half: String
    let time: String
    let stoppageTime: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(half)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.white.opacity(0.6))
                    Text(time)
                        .foregroundColor(.white)
                }
                
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.white.opacity(0.6))
                    Text("+\(stoppageTime) min")
                        .foregroundColor(.white)
                }
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct CardEventRow: View {
    let event: CardEvent
    let gameState: GameState
    
    var body: some View {
        HStack {
            CardView(
                cardType: event.cardType,
                playerNumber: event.playerNumber,
                isSecondYellow: false
            )
            .frame(width: 30, height: 42)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(event.team == .home ? gameState.homeTeam : gameState.awayTeam)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("Player #\(event.playerNumber)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("\(event.reason)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Text("\(event.time / 60)' - \(event.half == 1 ? "1 Half" : event.half == 2 ? "2 Half" : event.half == 3 ? "ET1" : "ET2")")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
}

struct SubstitutionRow: View {
    let substitution: SubstitutionEvent
    let gameState: GameState
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.left.arrow.right.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(substitution.team == .home ? gameState.homeTeam : gameState.awayTeam)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Text("Player #\(substitution.playerOut) → #\(substitution.playerIn)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                HStack {
                    Text("\(substitution.time / 60)'")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    
                    Text("- \(substitution.half == 1 ? "1 Half" : substitution.half == 2 ? "2 Half" : substitution.half == 3 ? "ET1" : "ET2")")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.3))
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
        .padding()
    }
}





// MARK: - Helper Functions

func formatTime(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let secs = seconds % 60
    return String(format: "%02d:%02d", minutes, secs)
}
