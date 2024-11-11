//
//  GoalView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import SwiftUI

struct GoalView: View {
    let playerNumber: String
    let minute: Int
    let teamName: String
    let onTap: () -> Void
    let half: Int
    

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background circle
                Circle()
                    .fill(Color.gray)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

                // Soccer ball icon
                Image(systemName: "soccerball")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            .onTapGesture {
                onTap()
            }

            // Team name
            Text(teamName)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
                .truncationMode(.tail)
            
            HStack {
                // Time
                Text("\(minute)'")
                    .font(.system(size: 12))
                    .foregroundColor(.yellow)
                
                // Half
                Text(half == 1 ? "- 1st Half" : "- 2nd Half")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                    
            }

            // Player number
            Text("#\(playerNumber)")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical, 8)
    }
}
