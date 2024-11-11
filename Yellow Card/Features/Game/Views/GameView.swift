// Import SwiftUI framework
import SwiftUI

/// A view that represents the main game screen, containing the football field, scoreboard and game controls
struct GameView: View {
    // MARK: - Properties

    /// The observed game state object that holds all game-related data
    @ObservedObject var gameState: GameState
    /// Navigation path binding for handling navigation
    @Binding var path: NavigationPath
    /// State variable to control save options sheet visibility
    @State private var showingSaveOptions = false
    /// State variable to control exit confirmation alert visibility
    @State private var showingExitConfirmation = false
    /// State variable to control animation state
    @State private var isAnimating = false

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background football field
            FootballField()
                .ignoresSafeArea()

            ScrollView {
                VStack {
                    // Main game components
                    ScoreboardView(gameState: gameState)
                    GameControlView(gameState: gameState)
                }
                // Animate components sliding up and fading in
                .offset(y: isAnimating ? 0 : 30)
                .opacity(isAnimating ? 1 : 0)
            }
        }
        .toolbar {
            // Exit button in navigation bar
            ToolbarItem(placement: .navigationBarLeading) {
                ControlButton(
                    label: "Exit",
                    icon: "xmark.circle.fill",
                    size: .custom(iconSize: 18, textSize: 30, height: 60),
                    action: { showingExitConfirmation = true }
                )
            }

            // Save button in navigation bar
            ToolbarItem(placement: .navigationBarTrailing) {
                ControlButton(
                    label: "Save",
                    icon: "square.and.arrow.down.fill",
                    size: .custom(iconSize: 18, textSize: 30, height: 60),
                    action: { showingSaveOptions = true }
                )
            }
        }
        // Exit confirmation alert
        .alert("Are you sure you want to exit and delete current game?", isPresented: $showingExitConfirmation) {
            Button("Exit", role: .destructive) {
                exitGameAndDelete()
            }
            Button("Cancel", role: .cancel) {}
        }
        // Save options dialog
        .confirmationDialog("Save Game", isPresented: $showingSaveOptions, titleVisibility: .visible) {
            Button("Save Game") {
                saveGame()
            }
            Button("Save and Exit") {
                saveAndExitGame()
            }
            Button("Cancel", role: .cancel) {}
        }
        .navigationBarBackButtonHidden(true)
        // Animate components when view appears
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }

    // MARK: - Game Management Functions

    /// Saves the current game state
    private func saveGame() {
        gameState.saveGame()
    }

    /// Exits the game and deletes the current game state
    private func exitGameAndDelete() {
        gameState.cleanup()
        gameState.deleteGame()
        navigateToMainMenu()
    }

    /// Saves the current game state and exits to main menu
    private func saveAndExitGame() {
        gameState.cleanup()
        gameState.saveGame()
        navigateToMainMenu()
    }

    /// Navigates back to the main menu by resetting the navigation path
    private func navigateToMainMenu() {
        // Reset the navigation path to navigate back to the root
        path = NavigationPath()
    }
}


struct LayoutConstants {
    static let gameContentWidth: CGFloat = 0.9 // 90% of screen width
}


