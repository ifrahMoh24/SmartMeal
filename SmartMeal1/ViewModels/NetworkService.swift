//
//  NetworkService.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 08.06.2025.
//

import Foundation

class NetworkService: ObservableObject {
    static let shared = NetworkService()
    
    // Demo mode - set to true for reliable demo, false for real API
    private let demoMode = true
    private let baseURL = "https://api.spoonacular.com/recipes"
    private let apiKey = "demo_key" // Replace with real API key when ready
    
    private init() {}
    
    func searchRecipesByIngredients(_ ingredients: [String]) async throws -> [Recipe] {
        if demoMode {
            return generateDemoRecipes(from: ingredients)
        }
        
        // Real API implementation (when ready)
        let ingredientsString = ingredients.joined(separator: ",")
        let urlString = "\(baseURL)/findByIngredients?ingredients=\(ingredientsString)&number=5&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.serverError
            }
            
            let decoder = JSONDecoder()
            let apiRecipes = try decoder.decode([SpoonacularRecipe].self, from: data)
            
            return apiRecipes.map { convertToRecipe($0, ingredients: ingredients) }
        } catch {
            // Fallback to demo recipes if API fails
            return generateDemoRecipes(from: ingredients)
        }
    }
    
    private func generateDemoRecipes(from ingredients: [String]) -> [Recipe] {
        // Generate 2-3 realistic recipes based on ingredients
        let primaryIngredient = ingredients.first ?? "Mixed Ingredients"
        
        var recipes: [Recipe] = []
        
        // Recipe 1: Simple dish with detected ingredients
        recipes.append(Recipe(
            title: "\(primaryIngredient) Stir Fry",
            ingredients: ingredients + ["Olive Oil", "Salt", "Black Pepper", "Garlic Powder"],
            instructions: [
                "Heat olive oil in a large pan over medium-high heat",
                "Add \(ingredients.joined(separator: ", ")) to the pan",
                "Stir-fry for 5-7 minutes until tender",
                "Season with salt, pepper, and garlic powder",
                "Serve hot and enjoy!"
            ],
            cookingTime: 15,
            difficulty: "Easy",
            imageURL: nil,
            nutritionInfo: NutritionInfo(
                calories: 280,
                protein: 18.0,
                carbs: 25.0,
                fat: 12.0,
                fiber: 6.0
            ),
            tags: ["Quick", "Healthy", "AI Generated"]
        ))
        
        // Recipe 2: More complex dish
        if ingredients.count >= 2 {
            recipes.append(Recipe(
                title: "Gourmet \(primaryIngredient) Bowl",
                ingredients: ingredients + ["Rice", "Soy Sauce", "Sesame Oil", "Green Onions", "Sesame Seeds"],
                instructions: [
                    "Cook rice according to package instructions",
                    "Prepare \(ingredients.joined(separator: " and ")) by washing and chopping",
                    "Sauté ingredients in sesame oil for 8-10 minutes",
                    "Serve over rice and garnish with green onions and sesame seeds",
                    "Drizzle with soy sauce to taste"
                ],
                cookingTime: 25,
                difficulty: "Medium",
                imageURL: nil,
                nutritionInfo: NutritionInfo(
                    calories: 420,
                    protein: 22.0,
                    carbs: 55.0,
                    fat: 15.0,
                    fiber: 8.0
                ),
                tags: ["Healthy", "Asian-Inspired", "AI Generated"]
            ))
        }
        
        // Recipe 3: Creative fusion dish
        if ingredients.count >= 3 {
            recipes.append(Recipe(
                title: "Mediterranean \(primaryIngredient) Delight",
                ingredients: ingredients + ["Olive Oil", "Lemon Juice", "Oregano", "Feta Cheese", "Olives"],
                instructions: [
                    "Preheat oven to 400°F (200°C)",
                    "Arrange \(ingredients.joined(separator: ", ")) on a baking sheet",
                    "Drizzle with olive oil and lemon juice",
                    "Sprinkle with oregano and bake for 20 minutes",
                    "Top with crumbled feta cheese and olives before serving"
                ],
                cookingTime: 30,
                difficulty: "Medium",
                imageURL: nil,
                nutritionInfo: NutritionInfo(
                    calories: 350,
                    protein: 16.0,
                    carbs: 28.0,
                    fat: 20.0,
                    fiber: 7.0
                ),
                tags: ["Mediterranean", "Vegetarian", "AI Generated"]
            ))
        }
        
        return recipes
    }
    
    private func convertToRecipe(_ spoonacularRecipe: SpoonacularRecipe, ingredients: [String]) -> Recipe {
        return Recipe(
            title: spoonacularRecipe.title,
            ingredients: ingredients + ["Additional ingredients from API"],
            instructions: [
                "Follow the recipe instructions",
                "Cook according to API recommendations",
                "Season to taste",
                "Serve hot and enjoy!"
            ],
            cookingTime: 30,
            difficulty: "Medium",
            imageURL: spoonacularRecipe.image,
            nutritionInfo: NutritionInfo(
                calories: 350,
                protein: 25.0,
                carbs: 40.0,
                fat: 12.0,
                fiber: 8.0
            ),
            tags: ["API Recipe"]
        )
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError
    case decodingError
    case networkUnavailable
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .serverError:
            return "Server error occurred"
        case .decodingError:
            return "Failed to decode response"
        case .networkUnavailable:
            return "Network unavailable"
        }
    }
}

// MARK: - API Models
struct SpoonacularRecipe: Codable {
    let id: Int
    let title: String
    let image: String?
    let usedIngredients: [UsedIngredient]?
}

struct UsedIngredient: Codable {
    let name: String
}
