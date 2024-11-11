import SwiftUI

struct SavedGamesListView: View {
    @State private var savedGames: [GameState] = []
    @State private var isEditing: Bool = false

    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            BackgroundCirclesView()
                .ignoresSafeArea()

            VStack {
                Text("Saved Games")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                    .foregroundColor(.white)

                Spacer()

                GlassMorphicCard {
                    if savedGames.isEmpty {
                        Text("No saved games yet.")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                            .padding()
                    } else {
                        gameList
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .onAppear(perform: loadSavedGames)
    }

    private var backgroundGradient: some View {
        LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
    }

    private var gameList: some View {
        List {
            ForEach(savedGames) { game in
                NavigationLink(destination: SavedGameDetailView(gameState: game)) {
                    gameRow(for: game)
                }
                .listRowBackground(Color.clear)
                
            }
            .onDelete(perform: deleteGame)
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }

    private func gameRow(for game: GameState) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(game.homeTeam) vs \(game.awayTeam)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Date: \(formattedDate(game.date))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

    // MARK: - Helper Functions

    func loadSavedGames() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            savedGames = files.compactMap { url in
                if let data = try? Data(contentsOf: url),
                   let game = try? JSONDecoder().decode(GameState.self, from: data) {
                    return game
                }
                return nil
            }.sorted(by: { $0.date > $1.date })
        } catch {
            print("Failed to load saved games: \(error.localizedDescription)")
        }
    }

    func deleteGame(at offsets: IndexSet) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for index in offsets {
            let game = savedGames[index]
            let fileURL = directory.appendingPathComponent("\(game.id).json")
            do {
                try FileManager.default.removeItem(at: fileURL)
                savedGames.remove(at: index)
            } catch {
                print("Failed to delete game: \(error.localizedDescription)")
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    SavedGamesListView()
}

// MARK: - Supporting Views




