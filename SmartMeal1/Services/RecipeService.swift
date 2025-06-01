//
//  RecipeService.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//

import Foundation

class RecipeService {
    static let shared = RecipeService()
    
    // You can use Spoonacular API (free tier available)
    // Sign up at: https://spoonacular.com/food-api
    private let apiKey = "YOUR_API_KEY_HERE" // Replace with your API key
    private let baseURL = "https://api.spoonacular.com/recipes"
    
    func searchRecipesByIngredients(_ ingredients: [String]) async throws -> [Recipe] {
        // For demo purposes, using mock data
        // Replace with actual API call when you have API key
        
        // Simulate API delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock recipes based on ingredients
        return generateMockRecipes(for: ingredients)
    }
    
    // MARK: - Actual API Implementation (uncomment when you have API key)
    /*
    func searchRecipesByIngredients(_ ingredients: [String]) async throws -> [Recipe] {
        let ingredientsString = ingredients.joined(separator: ",")
        let urlString = "\(baseURL)/findByIngredients?ingredients=\(ingredientsString)&apiKey=\(apiKey)&number=10"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let apiRecipes = try JSONDecoder().decode([SpoonacularRecipe].self, from: data)
        
        return apiRecipes.map { $0.toRecipe() }
    }
    */
    
    // MARK: - Mock Data Generation
    private func generateMockRecipes(for ingredients: [String]) -> [Recipe] {
        let recipes = [
            Recipe(
                title: "Quick \(ingredients.first ?? "Veggie") Stir Fry",
                ingredients: ingredients + ["Soy sauce", "Garlic", "Ginger", "Oil"],
                instructions: [
                    "Heat oil in a large pan or wok",
                    "Add minced garlic and ginger, stir for 30 seconds",
                    "Add \(ingredients.joined(separator: ", ")), stir fry for 5 minutes",
                    "Add soy sauce and cook for 2 more minutes",
                    "Serve hot with rice"
                ],
                cookingTime: 15,
                difficulty: "Easy",
                imageURL: "https://images.unsplash.com/photo-1512058564366-18510be2db19",
                nutritionInfo: NutritionInfo(
                    calories: 250,
                    protein: 12.0,
                    carbs: 35.0,
                    fat: 8.0,
                    fiber: 6.0
                ),
                tags: ["Quick", "Healthy", "Vegetarian"]
            ),
            Recipe(
                title: "\(ingredients.first ?? "Fresh") Salad Bowl",
                ingredients: ingredients + ["Olive oil", "Lemon juice", "Salt", "Pepper"],
                instructions: [
                    "Wash and chop all vegetables",
                    "Mix in a large bowl",
                    "Prepare dressing with olive oil and lemon juice",
                    "Season with salt and pepper",
                    "Toss and serve"
                ],
                cookingTime: 10,
                difficulty: "Easy",
                imageURL: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd",
                nutritionInfo: NutritionInfo(
                    calories: 150,
                    protein: 5.0,
                    carbs: 20.0,
                    fat: 7.0,
                    fiber: 8.0
                ),
                tags: ["Healthy", "Quick", "Raw"]
            ),
            Recipe(
                title: "Roasted \(ingredients.joined(separator: " & "))",
                ingredients: ingredients + ["Olive oil", "Herbs", "Salt", "Black pepper"],
                instructions: [
                    "Preheat oven to 400°F (200°C)",
                    "Cut vegetables into even pieces",
                    "Toss with olive oil, salt, and herbs",
                    "Spread on baking sheet",
                    "Roast for 25-30 minutes until golden"
                ],
                cookingTime: 35,
                difficulty: "Medium",
                imageURL: "https://images.unsplash.com/photo-1506484381205-f7945653044d",
                nutritionInfo: NutritionInfo(
                    calories: 180,
                    protein: 4.0,
                    carbs: 28.0,
                    fat: 6.0,
                    fiber: 7.0
                ),
                tags: ["Healthy", "Roasted", "Vegetarian"]
            )
        ]
        
        return recipes
    }
}

// MARK: - Spoonacular API Models (for when you use real API)
struct SpoonacularRecipe: Codable {
    let id: Int
    let title: String
    let image: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    
    func toRecipe() -> Recipe {
        Recipe(
            title: title,
            ingredients: [], // Would need another API call for full details
            instructions: [], // Would need another API call for full details
            cookingTime: 30,
            difficulty: "Medium",
            imageURL: image,
            nutritionInfo: nil,
            tags: []
        )
    }
}