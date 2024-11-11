
import SwiftUI

struct EditCardEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameState: GameState
    let cardEvent: CardEvent
    
    @State private var playerNumber: String
    @State private var selectedCardType: CardEvent.CardType
    @State private var selectedTeam: CardEvent.Team
    @State private var selectedReason: String
    @State private var customReason: String
    let reasons = ["Foul", "Handball", "Unsporting Behavior", "Dissent", "Other"]
    
    // Gradient Colors
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    
    init(gameState: GameState, cardEvent: CardEvent) {
        self.gameState = gameState
        self.cardEvent = cardEvent
        _playerNumber = State(initialValue: cardEvent.playerNumber)
        _selectedCardType = State(initialValue: cardEvent.cardType)
        _selectedTeam = State(initialValue: cardEvent.team)
        _selectedReason = State(initialValue: reasons.contains(cardEvent.reason) ? cardEvent.reason : "Other")
        _customReason = State(initialValue: reasons.contains(cardEvent.reason) ? "" : cardEvent.reason)
    }
    
    var body: some View {
        ZStack {
            BackgroundGradientView(start: gradientStart, end: gradientEnd)
                .ignoresSafeArea()
            
            BackgroundCirclesView()
            
            VStack {
                HeaderView(imageName: "rectangle.stack.badge.plus",  headerText: "Add Card Event", subheaderText: "Enter the details of the card below.")
                    .padding(.top, 60)
                
                Spacer()
                
                
                ScrollView {
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 20) {
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
                            
                            FormSection(header: "Player Information") {
                                TextField("Player Number", text: $playerNumber)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            
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
                            
                            FormSection(header: "Reason") {
                                Picker("Select Reason", selection: $selectedReason) {
                                    ForEach(reasons, id: \.self) { reason in
                                        Text(reason).tag(reason)
                                    }
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
                            
                            HStack {
                                Button(action: deleteCard) {
                                    Text("Delete")
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                
                                Button(action: updateCard) {
                                    Text("Update")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            (playerNumber.isEmpty || (selectedReason == "Other" && customReason.isEmpty))
                                            ? Color.gray.opacity(0.5)
                                            : Color.blue
                                        )
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
    
    private func updateCard() {
        let reason = selectedReason == "Other" ? customReason : selectedReason
        let updatedEvent = CardEvent(
            id: cardEvent.id,
            playerNumber: playerNumber,
            cardType: selectedCardType,
            reason: reason,
            time: cardEvent.time,
            team: selectedTeam,
            half: cardEvent.half
        )
        
        if let index = gameState.cardEvents.firstIndex(where: { $0.id == cardEvent.id }) {
            gameState.cardEvents[index] = updatedEvent
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteCard() {
        gameState.cardEvents.removeAll { $0.id == cardEvent.id }
        presentationMode.wrappedValue.dismiss()
    }
}
