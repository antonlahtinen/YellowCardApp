//
//  EditPenaltyView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 12.11.2024.
//

import SwiftUI

struct EditPenaltyView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameState: GameState
    let penalty: PenaltyEvent
    
    @State private var playerNumber: String
    @State private var selectedTeam: PenaltyEvent.Team
    @State private var scored: Bool
    
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    
    init(gameState: GameState, penalty: PenaltyEvent) {
        self.gameState = gameState
        self.penalty = penalty
        _playerNumber = State(initialValue: penalty.playerNumber)
        _selectedTeam = State(initialValue: penalty.team)
        _scored = State(initialValue: penalty.scored)
    }
    
    var body: some View {
        ZStack {
            BackgroundGradientView(start: gradientStart, end: gradientEnd)
                .ignoresSafeArea()
            
            BackgroundCirclesView()
            
            VStack {
                HeaderView(
                    imageName: "soccerball",
                    headerText: "Edit Penalty",
                    subheaderText: "Modify the details of the penalty kick below."
                )
                .padding(.top, 60)
                
                Spacer()
                
                ScrollView {
                    GlassMorphicCard {
                        VStack(alignment: .leading, spacing: 20) {
                            FormSection(header: "Team") {
                                Picker("Team", selection: $selectedTeam) {
                                    Text(gameState.homeTeam).tag(PenaltyEvent.Team.home)
                                    Text(gameState.awayTeam).tag(PenaltyEvent.Team.away)
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
                            
                            FormSection(header: "Result") {
                                Picker("Result", selection: $scored) {
                                    Text("Scored").tag(true)
                                    Text("Missed").tag(false)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            HStack(spacing: 16) {
                                Button(action: updatePenalty) {
                                    Text("Update")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green.opacity(0.3))
                                        .cornerRadius(10)
                                }
                                .disabled(playerNumber.isEmpty)
                                
                                Button(action: deletePenalty) {
                                    Text("Delete")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red.opacity(0.3))
                                        .cornerRadius(10)
                                }
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
    
    private func updatePenalty() {
        if let index = gameState.penalties.firstIndex(where: { $0.id == penalty.id }) {
            // Remove old penalty from shootout score if it was scored
            if penalty.scored {
                if penalty.team == .home {
                    gameState.penaltyShootoutHomeScore -= 1
                } else {
                    gameState.penaltyShootoutAwayScore -= 1
                }
            }
            
            // Create updated penalty
            let updatedPenalty = PenaltyEvent(
                id: penalty.id,
                playerNumber: playerNumber,
                team: selectedTeam,
                time: penalty.time,
                half: penalty.half,
                scored: scored
            )
            
            // Update penalty in array
            gameState.penalties[index] = updatedPenalty
            
            // Add new penalty to shootout score if scored
            if scored {
                if selectedTeam == .home {
                    gameState.penaltyShootoutHomeScore += 1
                } else {
                    gameState.penaltyShootoutAwayScore += 1
                }
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }

    private func deletePenalty() {
        // Remove penalty shootout score if it was scored
        if penalty.scored {
            if penalty.team == .home {
                gameState.penaltyShootoutHomeScore -= 1
            } else {
                gameState.penaltyShootoutAwayScore -= 1
            }
        }
        
        gameState.penalties.removeAll { $0.id == penalty.id }
        presentationMode.wrappedValue.dismiss()
    }
}
