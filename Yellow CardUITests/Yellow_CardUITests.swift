import XCTest

final class Yellow_CardUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    // Test main menu layout and navigation
    func testMainMenuLayout() throws {
        // Test logo section
        let soccerballImage = app.images["soccerball"].firstMatch
        XCTAssertTrue(soccerballImage.waitForExistence(timeout: 2))
        
        let yellowCardText = app.staticTexts["Yellow Card"].firstMatch
        XCTAssertTrue(yellowCardText.waitForExistence(timeout: 2))
        
        let trackerText = app.staticTexts["Football Match Tracker"].firstMatch
        XCTAssertTrue(trackerText.waitForExistence(timeout: 2))
        
        // Test menu buttons
        let newGameButton = app.buttons["New Game, Start tracking a new match"].firstMatch
        let savedGamesButton = app.buttons["Saved Games, View your match history"].firstMatch
        
        XCTAssertTrue(newGameButton.waitForExistence(timeout: 2))
        XCTAssertTrue(savedGamesButton.waitForExistence(timeout: 2))
        
        // Test version text
        let versionText = app.staticTexts["Version 1.0.0"].firstMatch
        XCTAssertTrue(versionText.waitForExistence(timeout: 2))
    }
    
    // Test new game flow
    func testNewGameFlow() throws {
        // Tap new game button using the full label
        let newGameButton = app.buttons["New Game, Start tracking a new match"].firstMatch
        XCTAssertTrue(newGameButton.waitForExistence(timeout: 2))
        newGameButton.tap()
        
        // Test form inputs
        let homeTeamField = app.textFields["homeTeamNameTextField"].firstMatch
        let awayTeamField = app.textFields["awayTeamNameTextField"].firstMatch
        
        XCTAssertTrue(homeTeamField.waitForExistence(timeout: 2))
        XCTAssertTrue(awayTeamField.waitForExistence(timeout: 2))
        
        homeTeamField.tap()
        homeTeamField.typeText("Liverpool")
        
        awayTeamField.tap()
        awayTeamField.typeText("Arsenal")
        
        // Test start game validation
        let startButton = app.buttons["Start Match"].firstMatch
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()
        
        // Verify game view loaded
        let addCardButton = app.buttons["Add Card Event"].firstMatch
        let addSubstitutionButton = app.buttons["Add Substitution"].firstMatch
        
        XCTAssertTrue(addCardButton.waitForExistence(timeout: 2))
        XCTAssertTrue(addSubstitutionButton.waitForExistence(timeout: 2))
    }
    
    // Test game controls
    func testGameControls() throws {
        // Navigate to game
        let newGameButton = app.buttons["New Game, Start tracking a new match"].firstMatch
        XCTAssertTrue(newGameButton.waitForExistence(timeout: 2))
        newGameButton.tap()
        
        let homeTeamField = app.textFields["homeTeamNameTextField"].firstMatch
        let awayTeamField = app.textFields["awayTeamNameTextField"].firstMatch
        
        homeTeamField.tap()
        homeTeamField.typeText("Team A")
        
        awayTeamField.tap()
        awayTeamField.typeText("Team B")
        
        let startButton = app.buttons["Start Match"].firstMatch
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()
        
        // Test timer controls
        let playButton = app.buttons["play.circle.fill"].firstMatch
        XCTAssertTrue(playButton.waitForExistence(timeout: 2))
        playButton.tap()
        
        // Test adding events
        let addCardButton = app.buttons["Add Card Event"].firstMatch
        XCTAssertTrue(addCardButton.waitForExistence(timeout: 2))
        addCardButton.tap()
        
        let addCardText = app.staticTexts["Add Card Event"].firstMatch
        XCTAssertTrue(addCardText.waitForExistence(timeout: 2))
        
        // Dismiss card sheet
        let closeButton = app.buttons["Cancel"].firstMatch
        XCTAssertTrue(closeButton.waitForExistence(timeout: 2))
        closeButton.tap()
        
        let addSubstitutionButton = app.buttons["Add Substitution"].firstMatch
        XCTAssertTrue(addSubstitutionButton.waitForExistence(timeout: 2))
        addSubstitutionButton.tap()
        
        let addSubstitutionText = app.staticTexts["Add Substitution Event"].firstMatch
        XCTAssertTrue(addSubstitutionText.waitForExistence(timeout: 2))
    }
}
