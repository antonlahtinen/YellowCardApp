//
//  EditGoalView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 6.11.2024.
//

import SwiftUI

struct EditGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameState: GameState
    let goal: GoalEvent
    
    @State private var playerNumber: String
    @State private var selectedTeam: GoalEvent.Team
    
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    
    init(gameState: GameState, goal: GoalEvent) {
        self.gameState = gameState
        self.goal = goal
        _playerNumber = State(initialValue: goal.playerNumber)
        _selectedTeam = State(initialValue: goal.team)
    }
    
    var body: some View {
        ZStack {
            BackgroundGradientView(start: gradientStart, end: gradientEnd)
                .ignoresSafeArea()
            
            BackgroundCirclesView()
            
            VStack {
                HeaderView(
                    imageName: "soccerball",
                    headerText: "Edit Goal Event",
                    subheaderText: "Modify the details of the goal below."
                )
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
                        
                        HStack(spacing: 16) {
                            Button(action: updateGoal) {
                                Text("Update")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green.opacity(0.3))
                                    .cornerRadius(10)
                            }
                            .disabled(playerNumber.isEmpty)
                            
                            Button(action: deleteGoal) {
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
    
    private func updateGoal() {
        if let index = gameState.goals.firstIndex(where: { $0.id == goal.id }) {
            // Remove old goal from score
            if goal.team == .home {
                gameState.homeScore -= 1
            } else {
                gameState.awayScore -= 1
            }
            
            // Create updated goal
            let updatedGoal = GoalEvent(
                playerNumber: playerNumber,
                team: selectedTeam,
                time: goal.time,
                half: goal.half
            )
            
            // Update goal in array
            gameState.goals[index] = updatedGoal
            
            // Add new goal to score
            if selectedTeam == .home {
                gameState.homeScore += 1
            } else {
                gameState.awayScore += 1
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteGoal() {
        if goal.team == .home {
            gameState.homeScore -= 1
        } else {
            gameState.awayScore -= 1
        }
        
        gameState.goals.removeAll { $0.id == goal.id }
        presentationMode.wrappedValue.dismiss()
    }
}
