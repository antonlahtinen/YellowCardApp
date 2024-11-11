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
    
    var id = UUID()
    let playerOut: String
    let playerIn: String
    let time: Int
    let team: Team
    let half: Int
}


