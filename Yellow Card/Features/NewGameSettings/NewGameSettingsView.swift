import SwiftUI

/// A view that handles the setup of a new game, allowing users to configure team names and match duration
struct NewGameSettingsView: View {
    // MARK: - State Properties
    
    /// Name of the home team
    @State private var homeTeamName: String = ""
    /// Name of the away team
    @State private var awayTeamName: String = ""
    /// Duration of each half in minutes
    @State private var halfLength: Int = 45
    /// Controls the animation state of UI elements
    @State private var isAnimating = false
    
    @State private var showingCoinFlip = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.45),
                    Color(red: 0.1, green: 0.1, blue: 0.2)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                // Animated background effects
                BackgroundEffectsView()
                    .opacity(isAnimating ? 1 : 0)
                
                // Football field background
                FootballField()
                    .ignoresSafeArea()
                    .opacity(0.3)
                
                // Main content scroll view
                ScrollView {
                    VStack(spacing: 32) {
                        // Header section
                        HeaderView(imageName: "flag.2.crossed", headerText: "New Match Setup", subheaderText: "Configure your match settings")
                            .offset(y: isAnimating ? 0 : -30)
                            .opacity(isAnimating ? 1 : 0)
                        
                        // Team names input section
                        TeamSettingsSection(
                            homeTeamName: $homeTeamName,
                            awayTeamName: $awayTeamName
                        )
                        .frame(maxWidth: .infinity)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                        .offset(y: isAnimating ? 0 : 30)
                        .opacity(isAnimating ? 1 : 0)
                        
                        // Match duration settings section
                        MatchSettingsSection(halfLength: $halfLength
                        )
                        .frame(maxWidth: .infinity)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                        .offset(y: isAnimating ? 0 : 30)
                        .opacity(isAnimating ? 1 : 0)
                        
                        
                        if !homeTeamName.isEmpty && !awayTeamName.isEmpty {
                            Button {
                                showingCoinFlip = true
                            } label: {
                                Label("Coin Flip", systemImage: "circle.circle.fill")
                                    .frame(maxWidth: .infinity)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.ultraThinMaterial)
                                    )
                            }
                        }
                        
                        // Start game button
                        StartGameButton(
                            homeTeamName: homeTeamName,
                            awayTeamName: awayTeamName,
                            halfLength: halfLength
                        )
                        .frame(maxWidth: .infinity)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                        .offset(y: isAnimating ? 0 : 30)
                        .opacity(isAnimating ? 1 : 0)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 24)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Animate UI elements when view appears
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
        .sheet(isPresented: $showingCoinFlip) {
            CoinFlipView(
                homeTeam: homeTeamName,
                awayTeam: awayTeamName
            )
        }
        
    }
    
}

// MARK: - Supporting Views

/// A view for configuring team names
struct TeamSettingsSection: View {
    @Binding var homeTeamName: String
    @Binding var awayTeamName: String
    
    var body: some View {
        VStack(spacing: 24) {
            SectionTitle(title: "Teams", icon: "person.2.fill")
            
            // Home team name input
            CustomTextField(
                icon: "house.fill",
                placeholder: "Home Team Name",
                text: $homeTeamName
            )
            .accessibilityIdentifier("homeTeamNameTextField")
            
            // Away team name input
            CustomTextField(
                icon: "airplane",
                placeholder: "Away Team Name",
                text: $awayTeamName
            )
            .accessibilityIdentifier("awayTeamNameTextField")
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

/// A view for configuring match duration settings
struct MatchSettingsSection: View {
    @Binding var halfLength: Int
    
    var body: some View {
        VStack(spacing: 24) {
            SectionTitle(title: "Match Duration", icon: "clock.fill")
            
            VStack(spacing: 16) {
                // Display selected duration
                Text("\(halfLength) minutes")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // Duration adjustment controls
                HStack(spacing: 20) {
                    // Decrease duration button
                    Button(action: { if halfLength > 1 { halfLength -= 1 } }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                    }
                    
                    // Duration slider
                    Slider(value: .init(
                        get: { Double(halfLength) },
                        set: { halfLength = Int($0) }
                    ), in: 1...45, step: 1)
                    .accentColor(.white)
                    
                    // Increase duration button
                    Button(action: { if halfLength < 45 { halfLength += 1 } }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                .foregroundColor(.white)
                
                Text("per half")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

/// A button that initiates a new game with the configured settings
struct StartGameButton: View {
    let homeTeamName: String
    let awayTeamName: String
    let halfLength: Int
    
    /// Button is enabled only when both team names are provided
    private var isEnabled: Bool {
        !homeTeamName.isEmpty && !awayTeamName.isEmpty
    }
    
    var body: some View {
        NavigationLink(value: isEnabled ? NavigationDestination.gameView(
            GameState(
                homeTeam: homeTeamName,
                awayTeam: awayTeamName,
                halfDuration: halfLength * 60
            )
        ) : nil) {
            HStack {
                Text("Start Match")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Image(systemName: "play.circle.fill")
                    .font(.title3)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isEnabled ? Color.green.opacity(0.3) : Color.gray.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .disabled(!isEnabled)
    }
}

/// A custom styled text field with an icon
struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Leading icon
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 24)
            
            // Text input field
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.3))
                }
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

/// A view for section headers with an icon
struct SectionTitle: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
    }
}

// MARK: - Helper Views and Extensions

/// Adds placeholder functionality to any view
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    NewGameSettingsView()
}
