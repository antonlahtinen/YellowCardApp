import SwiftUI

/// A view that contains all the game controls including score, timer, cards and substitutions
struct GameControlView: View {
    // MARK: - Properties

    /// The observed game state object that holds all game-related data
    @ObservedObject var gameState: GameState
    /// State variable to control card sheet visibility
    @State private var showingCardSheet = false
    /// State variable to control animation state
    @State private var isAnimating = false
    /// State variable to control substitution sheet visibility
    @State private var showingSubstitutionSheet = false
    /// State variable to control reset alert visibility
    @State private var showingResetAlert = false
    /// State variable to control switch half alert visibility
    @State private var showingSwitchHalfAlert = false
    
    @State private var showingHalfPicker = false
    @State private var selectedHalf = 1

    // MARK: - Body

    var body: some View {
        VStack(spacing: 32) {
            // Score controls for both teams
            HStack(spacing: 20) {
                // Home team score control
                TeamScoreControl(
                    score: $gameState.homeScore,
                    teamName: $gameState.homeTeam,
                    gameState: gameState,
                    team: .home,
                    icon: "house.fill"
                )

                // Away team score control
                TeamScoreControl(
                    score: $gameState.awayScore,
                    teamName: $gameState.awayTeam,
                    gameState: gameState,
                    team: .away,
                    icon: "airplane"
                )
            }
            .offset(y: isAnimating ? 0 : 30)
            .opacity(isAnimating ? 1 : 0)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // Adjusted to use maxWidth

            HStack(spacing: 20) {
                // Timer control panel
                ControlPanel {
                    VStack {
                        Text("TIMER")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))

                        HStack(spacing: 24) {
                            // Play/Pause button
                            ControlButton(
                                icon: gameState.currentHalfState.isRunning ? "pause.circle.fill" : "play.circle.fill",
                                size: .large,
                                action: { gameState.startStopTimer() }
                            )

                            // Reset button
                            ControlButton(
                                icon: "stop.circle.fill",
                                size: .large,
                                action: { showingResetAlert = true }
                            )
                        }
                    }
                }

                .offset(y: isAnimating ? 0 : 30)
                .opacity(isAnimating ? 1 : 0)

                // Stoppage time control panel
                ControlPanel {
                    VStack {
                        Text("STOPPAGE TIME")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))

                        HStack(spacing: 24) {
                            // Decrease stoppage time button
                            ControlButton(
                                label: "-",
                                size: .large,
                                action: { gameState.subtractStoppageTime() }
                            )

                            // Stoppage time display
                            //Text("+\(gameState.currentHalfState.stoppageTime)")
                            //    .font(.system(size: 24, weight: .bold, design: .rounded))
                            //    .foregroundColor(.white)

                            // Increase stoppage time button
                            ControlButton(
                                label: "+",
                                size: .large,
                                action: { gameState.addStoppageTime() }
                            )
                        }
                    }
                }

                .offset(y: isAnimating ? 0 : 30)
                .opacity(isAnimating ? 1 : 0)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // Ensure the HStack respects the overall width

            // Half switch control
            ControlButton(
                label: "Switch Half",
                size: .medium,
                width: 250,
                action: { showingHalfPicker = true }
            )
            .offset(y: isAnimating ? 0 : 30)
            .opacity(isAnimating ? 1 : 0)
            .alert("Switch Half", isPresented: $showingHalfPicker) {
                Button("Cancel", role: .cancel) {}
                
                Button("1st Half") {
                    if gameState.currentHalfState.isRunning {
                        gameState.stopTimer()
                    }
                    gameState.half = 1
                    gameState.setupCurrentHalfBinding()
                }
                
                Button("2nd Half") {
                    if gameState.currentHalfState.isRunning {
                        gameState.stopTimer()
                    }
                    gameState.half = 2
                    gameState.setupCurrentHalfBinding()
                }
                
                Button("ET 1") {
                    if gameState.currentHalfState.isRunning {
                        gameState.stopTimer()
                    }
                    gameState.half = 3
                    gameState.setupCurrentHalfBinding()
                }
                
                Button("ET 2") {
                    if gameState.currentHalfState.isRunning {
                        gameState.stopTimer()
                    }
                    gameState.half = 4
                    gameState.setupCurrentHalfBinding()
                }
            } message: {
                Text("Select which half you want to switch to. The timer for the current half will be stopped.")
            }

            // Card events section
            VStack(spacing: 16) {
                // Add card button
                ControlButton(
                    label: "Add Card Event",
                    icon: "rectangle.stack.badge.plus",
                    size: .medium,
                    width: 250,
                    action: { showingCardSheet = true }
                )

                // Display card events if any exist
                if !gameState.cardEvents.isEmpty {
                    CardEventsPanel(events: gameState.cardEvents, gameState: gameState)
                }
            }
            .offset(y: isAnimating ? 0 : 30)
            .opacity(isAnimating ? 1 : 0)

            // Substitution events section
            VStack(spacing: 16) {
                // Add substitution button
                ControlButton(
                    label: "Add Substitution",
                    icon: "arrow.left.arrow.right.circle.fill",
                    size: .medium,
                    width: 250,
                    action: { showingSubstitutionSheet = true }
                )

                // Display substitutions if any exist
                if !gameState.substitutions.isEmpty {
                    SubstitutionsPanel(substitutions: gameState.substitutions, gameState: gameState)
                }
            }
            .offset(y: isAnimating ? 0 : 30)
            .opacity(isAnimating ? 1 : 0)

            Spacer()
        }
        .padding()
        // Sheet for adding card events
        .sheet(isPresented: $showingCardSheet) {
            AddCardEventView(gameState: gameState)
        }
        // Alert for timer reset confirmation
        .alert("Reset Timer", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                gameState.resetTimer()
            }
        } message: {
            Text("Are you sure you want to reset the timer?")
        }
        // Animate components when view appears
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
        // Sheet for adding substitutions
        .sheet(isPresented: $showingSubstitutionSheet) {
            AddSubstitutionView(gameState: gameState)
        }
    }
}

/// A view that displays and controls a team's score and goals
struct TeamScoreControl: View {
    // MARK: - Properties

    /// Binding to the team's score
    @Binding var score: Int
    /// Binding to the team's name
    @Binding var teamName: String
    /// The game state object
    @ObservedObject var gameState: GameState
    /// The team identifier (home/away)
    let team: GoalEvent.Team
    /// Icon name for the team
    var icon: String
    /// State variable to control add goal sheet visibility
    @State private var showingAddGoal = false
    /// Currently selected goal for editing
    @State private var selectedGoal: GoalEvent?

    /// Computed property to filter goals for this team
    var teamGoals: [GoalEvent] {
        gameState.goals.filter { $0.team == team }
    }

    // MARK: - Body

    var body: some View {
        ControlPanel {
            VStack(spacing: 16) {
                // Team name input field
                CustomTextField(
                    icon: icon,
                    placeholder: "Team Name",
                    text: $teamName
                )


                // Add goal button
                Button(action: { showingAddGoal = true }) {
                    Label("Add Goal", systemImage: "soccerball")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(10)
                }


                // Goals list
                if !teamGoals.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(teamGoals) { goal in
                                GoalView(
                                    playerNumber: goal.playerNumber,
                                    minute: goal.minute,
                                    teamName: teamName,
                                    onTap: {
                                        selectedGoal = goal
                                    },
                                    half: goal.half
                                )
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    .sheet(item: $selectedGoal) { goal in
                        EditGoalView(gameState: gameState, goal: goal)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView(gameState: gameState)
        }
    }
}

/// A view that displays a scrollable list of card events
struct CardEventsPanel: View {
    // MARK: - Properties

    /// Array of card events to display
    let events: [CardEvent]
    /// The game state object
    @ObservedObject var gameState: GameState
    /// Currently selected card for editing
    @State private var selectedCard: CardEvent?

    // MARK: - Body

    var body: some View {
        ControlPanel {
            ScrollView(.horizontal, showsIndicators: false) {
                // Set HStack alignment to .top
                HStack(alignment: .top, spacing: 16) {
                    ForEach(events) { event in
                        VStack(spacing: 8) {
                            // Card display
                            CardView(
                                cardType: event.cardType,
                                playerNumber: event.playerNumber,
                                isSecondYellow: gameState.isSecondYellowCard(for: event)
                            )
                            .onTapGesture {
                                selectedCard = event
                            }

                            // Team name
                            Text(event.team == .home ? gameState.homeTeam : gameState.awayTeam)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            HStack {
                                // Time of card
                                Text("\(event.time / 60)'")
                                    .font(.system(size: 12))
                                    .foregroundColor(.yellow)
                                
                                Text(event.half == 1 ? "- 1st Half" : event.half == 2 ? "- 2nd Half" : event.half == 3 ? "- ET1" : "- ET2")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            // Card reason
                            Text(event.reason)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .frame(width: 70)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $selectedCard) { card in
            EditCardEventView(gameState: gameState, cardEvent: card)
        }
    }
}


/// A view that displays a scrollable list of substitution events
struct SubstitutionsPanel: View {
    // MARK: - Properties

    /// Array of substitution events to display
    let substitutions: [SubstitutionEvent]
    /// The game state object
    @ObservedObject var gameState: GameState
    /// Currently selected substitution for editing
    @State private var selectedSubstitution: SubstitutionEvent?

    // MARK: - Body

    var body: some View {
        ControlPanel {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(substitutions) { sub in
                        VStack(spacing: 8) {
                            // Substitution display
                            SubstitutionView(
                                playerIn: sub.playerIn,
                                playerOut: sub.playerOut,
                                team: sub.team == .home ? gameState.homeTeam : gameState.awayTeam
                            )
                            .onTapGesture {
                                selectedSubstitution = sub
                            }

                            // Team name
                            Text(sub.team == .home ? gameState.homeTeam : gameState.awayTeam)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.7))
                            
                            HStack {
                                // Time of substitution
                                Text("\(sub.time / 60)'")
                                    .font(.system(size: 12))
                                    .foregroundColor(.yellow)
                                
                                Text(sub.half == 1 ? "- 1st Half" : sub.half == 2 ? "- 2nd Half" : sub.half == 3 ? "- ET1" : "- ET2")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            // Player numbers
                            Text("\(sub.playerOut) → \(sub.playerIn)")
                                .font(.system(size: 12))
                                .foregroundColor(.white)

                            

                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $selectedSubstitution) { sub in
            EditSubstitutionView(gameState: gameState, substitution: sub)
        }
    }
}

/// A reusable panel view with a glass-like background effect
struct ControlPanel<Content: View>: View {
    // MARK: - Properties

    /// The content to display inside the panel
    let content: Content

    // MARK: - Initialization

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
    }
}
