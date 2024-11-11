import SwiftUI

// MARK: - NavigationDestination Enum
/// Defines all possible navigation destinations within the app.
enum NavigationDestination: Hashable {
    case mainMenu
    case newGameSettings
    case savedGames
    case gameView(GameState) // Associated value to pass game state data
}

// MARK: - ContentView
struct ContentView: View {
    // MARK: - State Properties
    /// Manages the current navigation path.
    @State private var path = NavigationPath()

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            // Root view of the navigation stack
            MainMenuView()
                // Defines navigation destinations based on NavigationDestination enum
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .mainMenu:
                        MainMenuView()
                            .navigationBarBackButtonHidden(true) // Prevents back navigation to main menu
                    case .newGameSettings:
                        NewGameSettingsView()
                    case .savedGames:
                        SavedGamesListView()
                    case .gameView(let gameState):
                        // Passes game state and navigation path to GameView
                        GameView(gameState: gameState, path: $path)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}


