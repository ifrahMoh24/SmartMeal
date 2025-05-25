//
//  RecipeDetailView.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var isFavorite = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: recipe.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.orange.opacity(0.3))
                        .overlay(Image(systemName: "photo").font(.system(size: 40)).foregroundColor(.orange))
                }
                .frame(height: 250)
                .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 20) {
                        Label("\(recipe.cookingTime) min", systemImage: "clock")
                        Label(recipe.difficulty, systemImage: "star.fill")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    if let nutrition = recipe.nutritionInfo {
                        Text("Calories: \(nutrition.calories)")
                        Text("Protein: \(nutrition.protein)g")
                        Text("Carbs: \(nutrition.carbs)g")
                        Text("Fat: \(nutrition.fat)g")
                        Text("Fiber: \(nutrition.fiber)g")
                    }

                    Text("Ingredients")
                        .font(.headline)
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                    }

                    Text("Instructions")
                        .font(.headline)
                    ForEach(recipe.instructions.indices, id: \.self) { i in
                        Text("\(i + 1). \(recipe.instructions[i])")
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            isFavorite = recipeManager.favoriteRecipes.contains(where: { $0.id == recipe.id })
        }
    }

    private func toggleFavorite() {
        if isFavorite {
            recipeManager.removeFromFavorites(recipe)
        } else {
            recipeManager.addToFavorites(recipe)
        }
        isFavorite.toggle()
    }
}
