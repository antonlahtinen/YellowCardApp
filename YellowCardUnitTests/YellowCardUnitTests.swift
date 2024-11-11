import XCTest
@testable import Yellow_Card

final class YellowCardUnitTests: XCTestCase {
    var gameState: GameState!
    
    override func setUp() {
        super.setUp()
        gameState = GameState(homeTeam: "Liverpool", awayTeam: "Arsenal", halfDuration: 2700)
    }
    
    override func tearDown() {
        gameState = nil
        super.tearDown()
    }
    
    func testGameStateInitialization() {
        XCTAssertEqual(gameState.homeTeam, "Liverpool")
        XCTAssertEqual(gameState.awayTeam, "Arsenal")
        XCTAssertEqual(gameState.homeScore, 0)
        XCTAssertEqual(gameState.awayScore, 0)
        XCTAssertEqual(gameState.half, 1)
        XCTAssertFalse(gameState.currentHalfState.isRunning)
    }
    
    func testTimerControls() {
        gameState.startStopTimer()
        XCTAssertTrue(gameState.currentHalfState.isRunning)
        
        gameState.startStopTimer()
        XCTAssertFalse(gameState.currentHalfState.isRunning)
        
        gameState.resetTimer()
        XCTAssertEqual(gameState.currentHalfState.time, 0)
    }
    
    func testCardEvents() {
        let cardEvent = CardEvent(
            playerNumber: "10",
            cardType: .yellow,
            reason: "Foul",
            time: gameState.currentHalfState.time,
            team: .home,
            half: gameState.half
            
        )
        gameState.cardEvents.append(cardEvent)
        
        XCTAssertEqual(gameState.cardEvents.count, 1)
        
        // Test second yellow detection
        let secondYellow = CardEvent(
            playerNumber: "10",
            cardType: .yellow,
            reason: "Another Foul",
            time: gameState.currentHalfState.time,
            team: .home,
            half: gameState.half
        )
        
        XCTAssertTrue(gameState.isSecondYellowCard(for: secondYellow))
    }
    
    func testGoalEvents() {
        let goal = GoalEvent(
            playerNumber: "9",
            team: .home,
            time: gameState.currentHalfState.time,
            half: gameState.half
        )
        gameState.goals.append(goal)
        
        XCTAssertEqual(gameState.goals.count, 1)
        XCTAssertEqual(gameState.goals.first?.playerNumber, "9")
        XCTAssertEqual(gameState.goals.first?.team, .home)
    }
    
    func testHalfProgression() {
        XCTAssertEqual(gameState.half, 1)
        gameState.switchHalf()
        XCTAssertEqual(gameState.half, 2)
    }
}
