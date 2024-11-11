//
//  AddSubstitutionView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 6.11.2024.
//

import SwiftUI

struct AddSubstitutionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameState: GameState
    @State private var playerOut: String = ""
    @State private var playerIn: String = ""
    @State private var selectedTeam: SubstitutionEvent.Team = .home
    
    // Gradient Colors
    private let gradientStart = Color(red: 0.1, green: 0.2, blue: 0.45)
    private let gradientEnd = Color(red: 0.1, green: 0.1, blue: 0.2)
    
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
                        
                        Button(action: addSubstitution) {
                            Text("Confirm Substitution")
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
                    .padding()
                }
                .padding(.horizontal)
            }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    private func addSubstitution() {
        let substitution = SubstitutionEvent(
            playerOut: playerOut,
            playerIn: playerIn,
            time: gameState.currentHalfState.time,
            team: selectedTeam,
            half: gameState.half
        )
        gameState.addSubstitution(substitution)
        presentationMode.wrappedValue.dismiss()
    }
}
