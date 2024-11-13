import SwiftUI

struct InfoView: View {
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    @State public var isAnimating = false
    
    @Environment(\.colorScheme) private var systemColorScheme
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]),
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            BackgroundCirclesView()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon and Title
                    VStack(spacing: 16) {
                        Image(systemName: "soccerball")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("Yellow Card")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Version 1.2.0")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 40)
                    .offset(y: isAnimating ? 0 : -30)
                    .opacity(isAnimating ? 1 : 0)
                    
                    // Features Section
                    InfoSection(title: "Features", icon: "star.fill", isAnimating: $isAnimating) {
                        InfoBulletPoint(text: "Track live football matches")
                        InfoBulletPoint(text: "Record goals, cards, and substitutions")
                        InfoBulletPoint(text: "Save and review match history")
                        InfoBulletPoint(text: "Penalty shootout support")
                    }
                    
                    // How to Use Section
                    InfoSection(title: "How to Use", icon: "questionmark.circle.fill", isAnimating: $isAnimating) {
                        InfoBulletPoint(text: "Start a new game from the main menu")
                        InfoBulletPoint(text: "Enter team names and match duration")
                        InfoBulletPoint(text: "Use the game controls to track events")
                        InfoBulletPoint(text: "Save the game when finished")
                    }
                    
                    
                    // About Section
                    InfoSection(title: "About", icon: "info.circle.fill", isAnimating: $isAnimating) {
                        Text("Yellow Card is a football match tracking app designed for referees, coaches, and football enthusiasts. Keep track of all important match events with an easy-to-use interface.")
                            .foregroundColor(.white.opacity(0.7))
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let icon: String
    @Binding var isAnimating: Bool
    let content: Content
    
    init(title: String, icon: String, isAnimating: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self._isAnimating = isAnimating
        self.content = content()
    }
    
    var body: some View {
        GlassMorphicCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                content
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
            .padding()
        }
        .offset(y: isAnimating ? 0 : 30)
        .opacity(isAnimating ? 1 : 0)
        
    }
}

struct InfoBulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 7)
            
            Text(text)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal)
    }
}

#Preview {
    InfoView()
}
