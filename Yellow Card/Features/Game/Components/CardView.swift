//
//  CardView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import SwiftUI

struct CardView: View {
    let cardType: CardEvent.CardType
    let playerNumber: String
    let isSecondYellow: Bool
    
    var body: some View {
        ZStack {
            if isSecondYellow {
                // Split card for second yellow
                HStack(spacing: 0) {
                    // Yellow half
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 17)
                    
                    // Red half
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 17)
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .frame(width: 34, height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            } else {
                // Regular card
                RoundedRectangle(cornerRadius: 6)
                    .fill(cardType == .yellow ? Color.yellow : Color.red)
                    .frame(width: 34, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
            Text(playerNumber)
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .bold))
        }
    }
}
