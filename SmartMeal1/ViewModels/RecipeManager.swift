//
//  RecipeManager.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import Foundation

class RecipeManager: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var favoriteRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func generateRecipeFromIngredients(_ ingredients: [String]) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let recipe = try await generateRecipeWithAI(ingredients: ingredients)

            DispatchQueue.main.async {
                self.recipes.append(recipe)
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func addToFavorites(_ recipe: Recipe) {
        if !favoriteRecipes.contains(where: { $0.id == recipe.id }) {
            favoriteRecipes.append(recipe)
        }
    }

    func removeFromFavorites(_ recipe: Recipe) {
        favoriteRecipes.removeAll { $0.id == recipe.id }
    }

    private func generateRecipeWithAI(ingredients: [String]) async throws -> Recipe {
        return Recipe(
            title: "AI Generated Recipe",
            ingredients: ingredients + ["Salt", "Pepper", "Olive Oil"],
            instructions: [
                "Prepare all ingredients",
                "Cook according to AI recommendations",
                "Season to taste",
                "Serve hot"
            ],
            cookingTime: 30,
            difficulty: "Medium",
            imageURL: nil,
            nutritionInfo: NutritionInfo(
                calories: 350,
                protein: 25.0,
                carbs: 40.0,
                fat: 12.0,
                fiber: 8.0
            ),
            tags: ["AI Generated", "Quick"]
        )
    }
}
