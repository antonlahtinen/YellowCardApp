import SwiftUI

struct AddCardEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameState: GameState
    @State private var playerNumber: String = ""
    @State private var selectedCardType: CardEvent.CardType = .yellow
    @State private var selectedTeam: CardEvent.Team = .home
    @State private var selectedReason: String = ""
    @State private var customReason: String = ""
    let reasons = ["Foul", "Handball", "Unsporting Behavior", "Dissent"]

    // Gradient Colors
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)

    var body: some View {
        ZStack {
            // Background Gradient
            BackgroundGradientView(start: gradientStart, end: gradientEnd)
                .ignoresSafeArea()
            
            // Animated Background Circles
            BackgroundCirclesView()
            
            // Main Content
            VStack {
                HeaderView(imageName: "rectangle.stack.badge.plus",  headerText: "Add Card Event", subheaderText: "Enter the details of the card below.")
                    .padding(.top, 60)
                
                Spacer()
                
                ScrollView {
                    // Glassmorphic Form Container
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 20) {
                            // Team Selection Section
                            FormSection(header: "Team") {
                                Picker("Team", selection: $selectedTeam) {
                                    Text(gameState.homeTeam).tag(CardEvent.Team.home)
                                    Text(gameState.awayTeam).tag(CardEvent.Team.away)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            // Player Information Section
                            FormSection(header: "Player Information") {
                                TextField("Player Number", text: $playerNumber)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            
                            // Card Type Section
                            FormSection(header: "Card Type") {
                                Picker("Card Type", selection: $selectedCardType) {
                                    ForEach(CardEvent.CardType.allCases, id: \.self) { cardType in
                                        Text(cardType.rawValue.capitalized).tag(cardType)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            // Reason Section
                            FormSection(header: "Reason") {
                                Picker("Select Reason", selection: $selectedReason) {
                                    ForEach(reasons, id: \.self) { reason in
                                        Text(reason).tag(reason)
                                    }
                                    Text("Other").tag("Other")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                
                                if selectedReason == "Other" {
                                    TextField("Custom Reason", text: $customReason)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                }
                            }
                            
                            // Action Buttons
                            HStack {
                                Spacer()
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    addCardEvent()
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Add")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background((playerNumber.isEmpty || (selectedReason == "Other" && customReason.isEmpty)) ? Color.gray.opacity(0.5) : Color.blue)
                                        .cornerRadius(10)
                                }
                                .disabled(playerNumber.isEmpty || (selectedReason == "Other" && customReason.isEmpty))
                            }
                            
                        }
                        .padding()
                        
                    }
                    .padding(.horizontal)
                    
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Helper Functions

    func addCardEvent() {
        let reason = selectedReason == "Other" ? customReason : selectedReason
        let event = CardEvent(
            playerNumber: playerNumber,
            cardType: selectedCardType,
            reason: reason,
            time: gameState.currentHalfState.time,
            team: selectedTeam,
            half: gameState.half
        )
        
        // Check if this would be a second yellow before adding
        if selectedCardType == .yellow && gameState.isSecondYellowCard(for: event) {
            // Create red card instead
            let redCardEvent = CardEvent(
                playerNumber: playerNumber,
                cardType: .red,
                reason: "Second Yellow Card",
                time: gameState.currentHalfState.time,
                team: selectedTeam,
                half: gameState.half
            )
            gameState.cardEvents.append(redCardEvent)
        } else {
            gameState.cardEvents.append(event)
        }
    }
}






