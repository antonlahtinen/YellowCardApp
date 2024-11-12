//
//  SubstitutionEvent.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import Foundation

struct SubstitutionEvent: Identifiable, Codable, Equatable {
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
    let playerOut: String
    let playerIn: String
    let time: Int
    let team: Team
    let half: Int
}


