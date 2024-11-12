//
//  CardEvent.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import Foundation

struct CardEvent: Identifiable, Codable, Equatable {
    enum CardType: String, Codable, CaseIterable {
        case yellow = "Yellow Card"
        case red = "Red Card"
    }
    
    enum Team: String, Codable {
        case home = "Home"
        case away = "Away"
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
    
    var id = UUID()
    let playerNumber: String
    let cardType: CardType
    let reason: String
    let time: Int
    let team: Team
    let half: Int
    
    init(id: UUID = UUID(), playerNumber: String, cardType: CardType, reason: String, time: Int, team: Team, half: Int) {
        self.id = id
        self.playerNumber = playerNumber
        self.cardType = cardType
        self.reason = reason
        self.time = time
        self.team = team
        self.half = half
    }
}
