//
//  SubstitutionView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import SwiftUI

struct SubstitutionView: View {
    let playerIn: String
    let playerOut: String
    let team: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "arrow.left.arrow.right.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
        .padding(8)
        .cornerRadius(8)
    }
}
