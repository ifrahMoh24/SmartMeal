//
//  RecipeCard.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: recipe.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.orange.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.orange)
                    )
            }
            .frame(height: 120)
            .clipped()
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 12) {
                    Label("\(recipe.cookingTime) min", systemImage: "clock")
                    Label(recipe.difficulty, systemImage: "star.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)

                if !recipe.tags.isEmpty {
                    HStack {
                        ForEach(recipe.tags.prefix(2), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(8)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}
