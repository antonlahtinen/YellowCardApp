//
//  AddGoalView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 6.11.2024.
//

import SwiftUI

struct AddGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameState: GameState
    @State private var playerNumber: String = ""
    @State private var selectedTeam: GoalEvent.Team = .home
    
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    
    var body: some View {
        ZStack {
            BackgroundGradientView(start: gradientStart, end: gradientEnd)
                .ignoresSafeArea()
            
            BackgroundCirclesView()
            
            VStack {
                HeaderView(imageName: "soccerball", headerText: "Add goal event", subheaderText: "Enter the details of the goal below.")
                    .padding(.top, 60)
                
                Spacer()
                
                ScrollView {
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 20) {
                        FormSection(header: "Team") {
                            Picker("Team", selection: $selectedTeam) {
                                Text(gameState.homeTeam).tag(GoalEvent.Team.home)
                                Text(gameState.awayTeam).tag(GoalEvent.Team.away)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        FormSection(header: "Scorer") {
                            TextField("Player Number", text: $playerNumber)
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        Button(action: addGoal) {
                            Text("Add Goal")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.3))
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
    
    private func addGoal() {
        let goal = GoalEvent(
            playerNumber: playerNumber,
            team: selectedTeam,
            time: gameState.currentHalfState.time,
            half: gameState.half
        )
        gameState.goals.append(goal)
        
        if selectedTeam == .home {
            gameState.homeScore += 1
        } else {
            gameState.awayScore += 1
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
