import Foundation
import Combine

// MARK: - HalfState Class

/// Represents the state of a single half in a game, managing time, stoppage time, and timer controls.
/// Conforms to `ObservableObject` for state management, `Codable` for encoding and decoding half data,
/// and `Hashable` for use in hashed collections.
class HalfState: ObservableObject, Codable, Hashable {
    
    // MARK: - Published Properties
    
    /// The current time elapsed in the half, measured in seconds.
    @Published var time: Int = 0
    
    /// The additional time added to the half, typically for stoppage or injury time.
    @Published var stoppageTime: Int = 0
    
    /// Indicates whether the timer is currently running.
    @Published var isRunning: Bool = false
    
    // MARK: - Private Properties
    
    /// The timer object that increments the `time` property every second.
    private var timer: Timer?
    
    /// The total duration of the half in seconds.
    let halfDuration: Int
    
    // MARK: - Coding Keys
    
    /// Defines the keys used for encoding and decoding the `HalfState`.
    enum CodingKeys: CodingKey {
        case time, stoppageTime, isRunning, halfDuration
    }
    
    // MARK: - Initializers
    
    /// Initializes a new `HalfState` with a specified half duration.
    ///
    /// - Parameter halfDuration: The duration of the half in seconds.
    init(halfDuration: Int) {
        self.halfDuration = halfDuration
    }
    
    /// Initializes a new `HalfState` instance from decoded data.
    ///
    /// - Parameter decoder: The decoder to decode data from.
    /// - Throws: An error if decoding fails.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)
        stoppageTime = try container.decode(Int.self, forKey: .stoppageTime)
        isRunning = try container.decode(Bool.self, forKey: .isRunning)
        halfDuration = try container.decode(Int.self, forKey: .halfDuration)
    }
    
    // MARK: - Codable Conformance
    
    /// Encodes the `HalfState` into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(time, forKey: .time)
        try container.encode(stoppageTime, forKey: .stoppageTime)
        try container.encode(isRunning, forKey: .isRunning)
        try container.encode(halfDuration, forKey: .halfDuration)
    }
    
    // MARK: - Timer Control Methods
    
    /// Starts or stops the timer for the half.
    ///
    /// - If the timer is running, it will be stopped.
    /// - If the timer is stopped, it will start and increment `time` every second.
    func startStopTimer() {
        if isRunning {
            // If the timer is running, invalidate it to stop.
            timer?.invalidate()
        } else {
            // If the timer is not running, schedule a new timer to update time every second.
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.updateTime()
            }
        }
        // Toggle the running state.
        isRunning.toggle()
    }
    
    /// Updates the time elapsed in the half.
    ///
    /// - Increments `time` by one second.
    /// - Currently, the logic is simple, but can be extended to handle half duration limits or other conditions.
    private func updateTime() {
        if time < halfDuration {
            time += 1
        } else {
            time += 1
            // Additional logic can be added here if needed when half duration is reached.
        }
    }
    
    /// Resets the timer and related properties to their initial states.
    ///
    /// - Stops the timer.
    /// - Resets `time` and `stoppageTime` to zero.
    /// - Sets `isRunning` to `false`.
    func resetTimer() {
        timer?.invalidate()
        time = 0
        stoppageTime = 0
        isRunning = false
    }
    
    /// Adds one second to the stoppage time.
    func addStoppageTime() {
        stoppageTime += 1
    }
    
    /// Subtracts one second from the stoppage time, ensuring it doesn't go below zero.
    func subtractStoppageTime() {
        if stoppageTime > 0 {
            stoppageTime -= 1
        }
    }
    
    /// Stops the timer without resetting the time values.
    ///
    /// - Sets `isRunning` to `false`.
    /// - Invalidates and removes the timer.
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Deinitializer
    
    /// Called just before the instance is deallocated.
    /// Ensures that the timer is invalidated to prevent it from running after deallocation.
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Hashable Conformance
    
    /// Determines if two `HalfState` instances are equal based on their properties.
    ///
    /// - Parameters:
    ///   - lhs: The first `HalfState`.
    ///   - rhs: The second `HalfState`.
    /// - Returns: `true` if all properties are equal, otherwise `false`.
    static func == (lhs: HalfState, rhs: HalfState) -> Bool {
        return lhs.time == rhs.time &&
               lhs.stoppageTime == rhs.stoppageTime &&
               lhs.isRunning == rhs.isRunning &&
               lhs.halfDuration == rhs.halfDuration
    }
    
    /// Hashes the essential components of `HalfState` to contribute to the hash value.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
        hasher.combine(stoppageTime)
        hasher.combine(isRunning)
        hasher.combine(halfDuration)
    }
}
