import Foundation
import Combine

// MARK: - GameState Class

/// Represents the state of a game, managing scores, teams, events, and timers.
/// Conforms to `ObservableObject` for state management, `Identifiable` for unique identification,
/// and `Codable` for encoding and decoding game data.
class GameState: ObservableObject, Identifiable, Codable {
    @Published var half: Int
    @Published var homeScore: Int
    @Published var awayScore: Int
    @Published var homeTeam: String
    @Published var awayTeam: String
    @Published var halves: [HalfState]
    @Published var cardEvents: [CardEvent] = []
    @Published var substitutions: [SubstitutionEvent] = []
    @Published var goals: [GoalEvent] = []
    
    // MARK: - Private Properties
    
    /// A set to hold Combine cancellables for managing subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Identifiable Properties
    
    /// A unique identifier for the game state.
    let id: UUID
    
    /// The date and time when the game state was created.
    let date: Date
    
    // MARK: - Coding Keys
    
    /// Defines the keys used for encoding and decoding the `GameState`.
    enum CodingKeys: CodingKey {
        case id, date, half, homeScore, awayScore, homeTeam, awayTeam, halves, cardEvents, substitutions, goals
    }
    
    // MARK: - Computed Properties
    
    /// Retrieves the current `HalfState` based on the `half` property.
    var currentHalfState: HalfState {
        halves[half - 1]
    }
    
    // MARK: - Initializers
    
    /// Initializes a new `GameState` with specified teams and half duration.
    init(id: UUID = UUID(), homeTeam: String, awayTeam: String, halfDuration: Int) {
        self.id = UUID()
        self.date = Date()
        self.half = 1
        self.homeScore = 0
        self.awayScore = 0
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        _halves = Published(initialValue: [
            HalfState(halfDuration: halfDuration),
            HalfState(halfDuration: halfDuration)
        ])
        
        setupCurrentHalfBinding()
    }
    
    /// Initializes a new `GameState` instance from decoded data.
    ///
    /// - Parameter decoder: The decoder to decode data from.
    /// - Throws: An error if decoding fails.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        half = try container.decode(Int.self, forKey: .half)
        homeScore = try container.decode(Int.self, forKey: .homeScore)
        awayScore = try container.decode(Int.self, forKey: .awayScore)
        homeTeam = try container.decode(String.self, forKey: .homeTeam)
        awayTeam = try container.decode(String.self, forKey: .awayTeam)
        _halves = Published(initialValue: try container.decode([HalfState].self, forKey: .halves))
        cardEvents = try container.decode([CardEvent].self, forKey: .cardEvents)
        substitutions = try container.decode([SubstitutionEvent].self, forKey: .substitutions)
        goals = try container.decode([GoalEvent].self, forKey: .goals)
        
        setupCurrentHalfBinding()
    }
    
    // MARK: - Deinitializer
    
    /// Called just before the instance is deallocated.
    deinit {
        print("GameState with ID \(id) has been deinitialized.")
    }
    
    // MARK: - Codable Conformance
    
    /// Encodes the `GameState` into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(half, forKey: .half)
        try container.encode(homeScore, forKey: .homeScore)
        try container.encode(awayScore, forKey: .awayScore)
        try container.encode(homeTeam, forKey: .homeTeam)
        try container.encode(awayTeam, forKey: .awayTeam)
        try container.encode(halves, forKey: .halves)
        try container.encode(cardEvents, forKey: .cardEvents)
        try container.encode(substitutions, forKey: .substitutions)
        try container.encode(goals, forKey: .goals)
    }
    
    // MARK: - Private Methods
    
    /// Sets up a binding to observe changes in the current half's state.
    /// When `currentHalfState` emits `objectWillChange`, this method forwards it to the `GameState`'s `objectWillChange`.
    private func setupCurrentHalfBinding() {
        currentHalfState.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Timer Control Methods
    
    /// Starts or stops the timer for the current half.
    func startStopTimer() {
        currentHalfState.startStopTimer()
    }
    
    /// Resets the timer for the current half.
    func resetTimer() {
        currentHalfState.resetTimer()
    }
    
    
    var periodName: String {
            switch half {
                case 1: return "1st Half"
                case 2: return "2nd Half"
                case 3: return "ET1"
                case 4: return "ET2"
                default: return ""
            }
        }
    /// Switches the current half (e.g., from first to second half).
    func switchHalf() {
            if half < 4 {
                half += 1
                cancellables.removeAll()
                setupCurrentHalfBinding()
            }
        }
    
    /// Adds stoppage time to the current half.
    func addStoppageTime() {
        currentHalfState.addStoppageTime()
    }
    
    /// Subtracts stoppage time from the current half.
    func subtractStoppageTime() {
        currentHalfState.subtractStoppageTime()
    }
    
    /// Stops all timers for both halves.
    func stopTimers() {
        halves.forEach { $0.stopTimer() }
    }
    
    /// Cleans up resources by stopping timers and removing all cancellables.
    func cleanup() {
        stopTimers()
        cancellables.removeAll()
    }
    
    // MARK: - Event Management
    
    /// Adds a substitution event to the game.
    ///
    /// - Parameter substitution: The `SubstitutionEvent` to add.
    func addSubstitution(_ substitution: SubstitutionEvent) {
        substitutions.append(substitution)
    }
}

// MARK: - Hashable Conformance

extension GameState: Hashable {
    
    /// Determines if two `GameState` instances are equal based on their `id`.
    ///
    /// - Parameters:
    ///   - lhs: The first `GameState`.
    ///   - rhs: The second `GameState`.
    /// - Returns: `true` if both have the same `id`, otherwise `false`.
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// Hashes the essential components of `GameState` to contribute to the hash value.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Persistence Methods

extension GameState {
    
    /// Saves the current game state to a JSON file in the documents directory.
    func saveGame() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            let url = getDocumentsDirectory().appendingPathComponent("\(id.uuidString).json")
            try data.write(to: url)
            print("Game saved with ID: \(id)")
        } catch {
            print("Failed to save game: \(error.localizedDescription)")
        }
    }
    
    /// Deletes the saved game file from the documents directory.
    func deleteGame() {
        let url = getDocumentsDirectory().appendingPathComponent("\(id.uuidString).json")
        do {
            try FileManager.default.removeItem(at: url)
            print("Game deleted with ID: \(id)")
        } catch {
            print("Failed to delete game: \(error.localizedDescription)")
        }
    }
    
    /// Retrieves the URL of the app's documents directory.
    ///
    /// - Returns: The URL of the documents directory.
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

// MARK: - Utility Methods

extension GameState {
    
    /// Determines if a given `CardEvent` is a second yellow card for a player.
    ///
    /// - Parameter event: The `CardEvent` to evaluate.
    /// - Returns: `true` if it's a second yellow card, otherwise `false`.
    func isSecondYellowCard(for event: CardEvent) -> Bool {
        // Check if the card type is yellow
        guard event.cardType == .yellow else { return false }
        
        // Filter previous yellow cards for the same player and team, excluding the current event
        let previousYellowCards = cardEvents.filter { previousEvent in
            previousEvent.id != event.id &&
            previousEvent.team == event.team &&
            previousEvent.playerNumber == event.playerNumber &&
            previousEvent.cardType == .yellow
        }
        
        // If there is at least one previous yellow card, it's a second yellow
        return !previousYellowCards.isEmpty
    }
}
