//
//  AddPenaltyView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 12.11.2024.
//

import SwiftUI

struct AddPenaltyView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameState: GameState
    @State private var playerNumber: String = ""
    @State private var selectedTeam: PenaltyEvent.Team = .home
    @State private var scored: Bool = true
    
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    
    var body: some View {
        ZStack {
            BackgroundGradientView(start: gradientStart, end: gradientEnd)
                .ignoresSafeArea()
            
            BackgroundCirclesView()
            
            VStack {
                HeaderView(
                    imageName: "soccerball",
                    headerText: "Add Penalty",
                    subheaderText: "Enter the details of the penalty kick below."
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
                            
                            Button(action: addPenalty) {
                                Text("Add Penalty")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        playerNumber.isEmpty
                                        ? Color.gray.opacity(0.5)
                                        : Color.blue
                                    )
                                    .cornerRadius(10)
                            }
                            .disabled(playerNumber.isEmpty)
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
    
    private func addPenalty() {
        let penalty = PenaltyEvent(
            playerNumber: playerNumber,
            team: selectedTeam,
            time: gameState.currentHalfState.time,
            half: gameState.half,
            scored: scored
        )
        gameState.addPenalty(penalty)
        presentationMode.wrappedValue.dismiss()
    }
}
