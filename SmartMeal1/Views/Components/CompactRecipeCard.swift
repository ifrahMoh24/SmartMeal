//
//  CompactRecipeCard.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import SwiftUI

struct CompactRecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: recipe.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.orange.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.caption)
                            .foregroundColor(.orange)
                    )
            }
            .frame(width: 80, height: 80)
            .clipped()
            .cornerRadius(8)

            Text(recipe.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
    }
}
