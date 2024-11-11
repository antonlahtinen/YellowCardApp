//
//  GoalEvent.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import Foundation

struct GoalEvent: Identifiable, Codable, Equatable {
    let id: UUID
    let playerNumber: String
    let team: Team
    let time: Int
    let minute: Int
    let half: Int
    
    enum Team: String, Codable {
        case home
        case away
    }
    
    var periodName: String {
            switch half {
                case 1: return "1st Half"
                case 2: return "2nd Half"
                case 3: return "ET1"
                case 4: return "ET2"
                default: return ""
            }
        }
    
    init(playerNumber: String, team: Team, time: Int, half: Int) {
        self.id = UUID()
        self.playerNumber = playerNumber
        self.team = team
        self.time = time
        self.minute = time / 60
        self.half = half
    }
}
