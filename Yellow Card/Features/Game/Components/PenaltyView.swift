//
//  PenaltyView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 12.11.2024.
//

import SwiftUI

struct PenaltyView: View {
    let playerNumber: String
    let teamName: String
    let scored: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(scored ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Image(systemName: scored ? "soccerball" : "xmark")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            .onTapGesture {
                onTap()
            }
            
            Text(teamName)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
                .truncationMode(.tail)
            
            
            Text("#\(playerNumber)")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical, 8)
    }
}
