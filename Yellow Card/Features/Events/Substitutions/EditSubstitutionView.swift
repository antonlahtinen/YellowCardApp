//
//  EditSubstitutionView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 6.11.2024.
//

import SwiftUI

struct EditSubstitutionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameState: GameState
    let substitution: SubstitutionEvent
    
    @State private var playerOut: String
    @State private var playerIn: String
    @State private var selectedTeam: SubstitutionEvent.Team
    
    // Gradient Colors
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    
    init(gameState: GameState, substitution: SubstitutionEvent) {
        self.gameState = gameState
        self.substitution = substitution
        _playerOut = State(initialValue: substitution.playerOut)
        _playerIn = State(initialValue: substitution.playerIn)
        _selectedTeam = State(initialValue: substitution.team)
    }
    
    var body: some View {
        ZStack {
            BackgroundGradientView(start: gradientStart, end: gradientEnd)
                .ignoresSafeArea()
            
            BackgroundCirclesView()
            
            VStack {
                HeaderView(imageName: "arrow.left.arrow.right.circle.fill", headerText: "Add Substitution Event", subheaderText: "Enter the details of the substitution below.")
                    .padding(.top, 60)
                
                Spacer()
                
                ScrollView {
                GlassMorphicCard {
                    VStack(alignment: .leading, spacing: 20) {
                        FormSection(header: "Team") {
                            Picker("Team", selection: $selectedTeam) {
                                Text(gameState.homeTeam).tag(SubstitutionEvent.Team.home)
                                Text(gameState.awayTeam).tag(SubstitutionEvent.Team.away)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        FormSection(header: "Player Out") {
                            TextField("Player Number", text: $playerOut)
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        FormSection(header: "Player In") {
                            TextField("Player Number", text: $playerIn)
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        HStack {
                            Button(action: deleteSubstitution) {
                                Text("Delete")
                                    .foregroundColor(.red)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            
                            Button(action: updateSubstitution) {
                                Text("Update")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        (playerOut.isEmpty || playerIn.isEmpty)
                                        ? Color.gray.opacity(0.5)
                                        : Color.blue
                                    )
                                    .cornerRadius(10)
                            }
                            .disabled(playerOut.isEmpty || playerIn.isEmpty)
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
    
    private func updateSubstitution() {
        let updatedSubstitution = SubstitutionEvent(
            id: substitution.id,
            playerOut: playerOut,
            playerIn: playerIn,
            time: substitution.time,
            team: selectedTeam,
            half: substitution.half
        )
        
        if let index = gameState.substitutions.firstIndex(where: { $0.id == substitution.id }) {
            gameState.substitutions[index] = updatedSubstitution
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteSubstitution() {
        gameState.substitutions.removeAll { $0.id == substitution.id }
        presentationMode.wrappedValue.dismiss()
    }
}
