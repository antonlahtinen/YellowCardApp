import SwiftUI

struct MainMenuView: View {
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated Background
                LinearGradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.45),
                    Color(red: 0.1, green: 0.1, blue: 0.2)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                // Dynamic Background Elements
                BackgroundEffectsView()
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 1.0), value: isAnimating)
                
                FootballField()
                    .ignoresSafeArea()
                    .opacity(0.3)
                
                // Main Content
                VStack(spacing: 0) {
                    // Logo and Title Section
                    LogoSection(geometry: geometry)
                        .offset(y: isAnimating ? 0 : -geometry.size.height * 0.05)
                        .opacity(isAnimating ? 1 : 0)
                    
                    Spacer()
                    
                    // Menu Options
                    MenuOptionsButtons()
                        .offset(y: isAnimating ? 0 : geometry.size.height * 0.05)
                        .opacity(isAnimating ? 1 : 0)
                    
                    Spacer()
                    
                    // Footer
                    FooterView()
                        .opacity(isAnimating ? 0.7 : 0)
                }
                .padding(.vertical, geometry.size.height * 0.05)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                isAnimating = true
            }
        }
    }
}




// MARK: - Supporting Views


struct LogoSection: View {
    let geometry: GeometryProxy
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.03) {
            // App Icon
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                
                Image(systemName: "soccerball")
                    .font(.system(size: geometry.size.width * 0.125))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
            }
            
            // Title
            VStack(spacing: geometry.size.height * 0.01) {
                Text("Yellow Card")
                    .font(.system(size: geometry.size.width * 0.1, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Football Match Tracker")
                    .font(.system(size: geometry.size.width * 0.05))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.top, geometry.size.height * 0.05)
    }
}


struct MenuOptionsButtons: View {
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.03) {
            // New Game NavigationLink
            NavigationLink(value: NavigationDestination.newGameSettings) {
                MenuButton(
                    title: "New Game",
                    subtitle: "Start tracking a new match",
                    icon: "play.fill"
                )
                .accessibilityIdentifier("newGameButton")
            }
            
            // Saved Games NavigationLink
            NavigationLink(value: NavigationDestination.savedGames) {
                MenuButton(
                    title: "Saved Games",
                    subtitle: "View your match history",
                    icon: "folder.fill"
                )
                .accessibilityIdentifier("savedGamesButton")
            }
            
            // Info/About NavigationLink
            NavigationLink(value: NavigationDestination.info) {
                MenuButton(
                    title: "About",
                    subtitle: "App information and help",
                    icon: "info.circle.fill"
                )
                .accessibilityIdentifier("infoButton")
            }
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
    }
}




struct FooterView: View {
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.01) {
            Text("Version 1.2.0")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
    }
}


// MARK: - Preview
#Preview {
    MainMenuView()
}
