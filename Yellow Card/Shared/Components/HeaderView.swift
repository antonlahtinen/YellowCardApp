//
//  HeaderView.swift
//  Yellow Card
//
//  Created by Anton Lahtinen on 7.11.2024.
//

import SwiftUI

struct HeaderView: View {
    let imageName: String
    let headerText: String
    let subheaderText: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: imageName)
                .font(.system(size: 44))
                .foregroundColor(.white)
            
            Text(headerText)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(subheaderText)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical)
    }
}
