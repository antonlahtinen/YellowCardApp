//
//  PenaltyEvent.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 12.11.2024.
//

import Foundation

struct PenaltyEvent: Identifiable, Codable {
    let id: UUID
    let playerNumber: String
    let team: Team
    let time: Int
    let half: Int
    let scored: Bool
    
    enum Team: String, Codable {
        case home, away
    }
    
    init(id: UUID = UUID(), playerNumber: String, team: Team, time: Int, half: Int, scored: Bool) {
        self.id = id
        self.playerNumber = playerNumber
        self.team = team
        self.time = time
        self.half = half
        self.scored = scored
    }
}
