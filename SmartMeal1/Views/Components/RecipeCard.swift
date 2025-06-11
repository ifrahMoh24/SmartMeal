//
//  RecipeCard.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image container
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: recipe.imageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.orange.opacity(0.3),
                                            Color.orange.opacity(0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.black.opacity(0.3),
                                        Color.clear
                                    ]),
                                    startPoint: .bottom,
                                    endPoint: .center
                                )
                            )
                    case .failure(_):
                        ZStack {
                            Rectangle()
                                .fill(Color.orange.opacity(0.2))
                            
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 30))
                                    .foregroundColor(.orange)
                                Text("Image not available")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 180)
                .clipped()
                
                // Difficulty badge
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                    Text(recipe.difficulty)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 5)
                )
                .padding(12)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 10) {
                Text(recipe.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("\(recipe.cookingTime) min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let calories = recipe.nutritionInfo?.calories {
                        HStack(spacing: 4) {
                            Image(systemName: "flame")
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text("\(calories) cal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if !recipe.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(recipe.tags.prefix(3), id: \.self) { tag in
                                TagView(tag: tag)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(
                    color: isHovered ? Color.orange.opacity(0.2) : Color.black.opacity(0.08),
                    radius: isHovered ? 15 : 10,
                    x: 0,
                    y: isHovered ? 8 : 5
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(isHovered ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isHovered ? 1.02 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct TagView: View {
    let tag: String
    
    var body: some View {
        Text(tag)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.orange.opacity(0.1))
            )
            .foregroundColor(.orange)
            .overlay(
                Capsule()
                    .strokeBorder(Color.orange.opacity(0.2), lineWidth: 0.5)
            )
    }
}
