//
//  RecipeManager.swift
//  SmartMeal1
//
//

import Foundation

class RecipeManager: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var favoriteRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastGeneratedRecipes: [Recipe] = []
    
    private let networkService = NetworkService.shared
    
    init() {
        loadSampleRecipes()
        loadFavorites()
    }
    
    func generateRecipeFromIngredients(_ ingredients: [String]) async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let newRecipes = try await networkService.searchRecipesByIngredients(ingredients)

            await MainActor.run {
                self.recipes.append(contentsOf: newRecipes)
                self.lastGeneratedRecipes = newRecipes
                self.isLoading = false
                
                // Show success message
                print("✅ Successfully generated \(newRecipes.count) recipes!")
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                
                // Add fallback recipe even on error
                let fallbackRecipe = self.createFallbackRecipe(ingredients: ingredients)
                self.recipes.append(fallbackRecipe)
                self.lastGeneratedRecipes = [fallbackRecipe]
                
                print("⚠️ Error generating recipes, using fallback: \(error.localizedDescription)")
            }
        }
    }

    func addToFavorites(_ recipe: Recipe) {
        if !favoriteRecipes.contains(where: { $0.id == recipe.id }) {
            favoriteRecipes.append(recipe)
            saveFavorites()
            print("❤️ Added \(recipe.title) to favorites")
        }
    }

    func removeFromFavorites(_ recipe: Recipe) {
        favoriteRecipes.removeAll { $0.id == recipe.id }
        saveFavorites()
        print("💔 Removed \(recipe.title) from favorites")
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        return favoriteRecipes.contains(where: { $0.id == recipe.id })
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        if isFavorite(recipe) {
            removeFromFavorites(recipe)
        } else {
            addToFavorites(recipe)
        }
    }
    
    func clearAllRecipes() {
        recipes.removeAll()
        lastGeneratedRecipes.removeAll()
        print("🗑️ Cleared all recipes")
    }
    
    func refreshRecipes() async {
        print("🔄 Refreshing recipes...")
        await generateRecipeFromIngredients(["Popular", "Trending", "Seasonal"])
    }
    
    func getRecipesByTag(_ tag: String) -> [Recipe] {
        if tag == "All" {
            return recipes
        }
        return recipes.filter { $0.tags.contains(tag) }
    }
    
    func searchRecipes(_ searchText: String) -> [Recipe] {
        if searchText.isEmpty {
            return recipes
        }
        
        return recipes.filter { recipe in
            recipe.title.localizedCaseInsensitiveContains(searchText) ||
            recipe.ingredients.joined().localizedCaseInsensitiveContains(searchText) ||
            recipe.tags.joined().localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Private Methods
    
    private func createFallbackRecipe(ingredients: [String]) -> Recipe {
        let primaryIngredient = ingredients.first ?? "Available Ingredients"
        
        return Recipe(
            title: "Quick \(primaryIngredient) Recipe",
            ingredients: ingredients + ["Salt", "Black Pepper", "Olive Oil", "Garlic"],
            instructions: [
                "Prepare all ingredients by washing and chopping as needed",
                "Heat 2 tablespoons of olive oil in a large pan over medium heat",
                "Add minced garlic and cook for 30 seconds until fragrant",
                "Add \(ingredients.joined(separator: ", ")) to the pan",
                "Cook for 10-15 minutes, stirring occasionally",
                "Season generously with salt and pepper to taste",
                "Serve hot and enjoy your delicious meal!"
            ],
            cookingTime: 20,
            difficulty: "Easy",
            imageURL: nil,
            nutritionInfo: NutritionInfo(
                calories: 250,
                protein: 15.0,
                carbs: 30.0,
                fat: 10.0,
                fiber: 5.0
            ),
            tags: ["Quick", "AI Generated", "Fallback", "Easy"]
        )
    }
    
    // Add to RecipeManager.swift - Replace sample recipes with images

    private func loadSampleRecipes() {
        let sampleRecipes = [
            Recipe(
                title: "Mediterranean Quinoa Power Bowl",
                ingredients: [
                    "Quinoa", "Cherry Tomatoes", "Cucumber", "Red Onion",
                    "Feta Cheese", "Kalamata Olives", "Extra Virgin Olive Oil",
                    "Lemon Juice", "Fresh Parsley", "Oregano"
                ],
                instructions: [
                    "Rinse 1 cup quinoa and cook according to package directions",
                    "While quinoa cooks, dice cucumber and halve cherry tomatoes",
                    "Thinly slice red onion and roughly chop fresh parsley",
                    "Combine cooked quinoa with prepared vegetables",
                    "Crumble feta cheese and add olives on top",
                    "Whisk olive oil, lemon juice, and oregano for dressing",
                    "Drizzle dressing over bowl and toss gently",
                    "Garnish with fresh parsley and serve immediately"
                ],
                cookingTime: 25,
                difficulty: "Easy",
                imageURL: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800", // Quinoa bowl
                nutritionInfo: NutritionInfo(
                    calories: 385,
                    protein: 16.5,
                    carbs: 45.0,
                    fat: 14.5,
                    fiber: 8.2
                ),
                tags: ["Healthy", "Vegetarian", "Mediterranean", "Bowl", "Protein-Rich"]
            ),
            Recipe(
                title: "Spicy Honey Garlic Chicken Stir-Fry",
                ingredients: [
                    "Chicken Breast", "Bell Peppers", "Broccoli", "Snap Peas",
                    "Garlic", "Fresh Ginger", "Honey", "Soy Sauce",
                    "Rice Vinegar", "Red Pepper Flakes", "Sesame Oil", "Green Onions"
                ],
                instructions: [
                    "Cut chicken breast into bite-sized pieces and season with salt",
                    "Slice bell peppers and cut broccoli into small florets",
                    "Mince garlic and ginger, then mix with honey, soy sauce, and vinegar",
                    "Heat sesame oil in a large wok over high heat",
                    "Cook chicken pieces until golden brown, about 5-6 minutes",
                    "Add vegetables and stir-fry for 3-4 minutes until tender-crisp",
                    "Pour in sauce mixture and red pepper flakes",
                    "Stir-fry for 2 more minutes until sauce thickens",
                    "Garnish with sliced green onions and serve over rice"
                ],
                cookingTime: 18,
                difficulty: "Medium",
                imageURL: "https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800", // Stir fry
                nutritionInfo: NutritionInfo(
                    calories: 320,
                    protein: 35.0,
                    carbs: 22.0,
                    fat: 12.0,
                    fiber: 4.5
                ),
                tags: ["Protein-Rich", "Spicy", "Asian-Inspired", "Stir-Fry", "Chicken"]
            ),
            Recipe(
                title: "Creamy Avocado Pasta with Cherry Tomatoes",
                ingredients: [
                    "Whole Wheat Pasta", "Ripe Avocados", "Cherry Tomatoes", "Fresh Basil",
                    "Garlic", "Lemon Juice", "Parmesan Cheese", "Pine Nuts",
                    "Extra Virgin Olive Oil", "Red Pepper Flakes"
                ],
                instructions: [
                    "Cook pasta according to package directions until al dente",
                    "While pasta cooks, halve cherry tomatoes and mince garlic",
                    "Mash ripe avocados with lemon juice, garlic, and olive oil",
                    "Season avocado mixture with salt and pepper",
                    "Drain pasta and reserve 1/2 cup pasta water",
                    "Toss hot pasta with avocado cream, adding pasta water as needed",
                    "Gently fold in cherry tomatoes and fresh basil",
                    "Serve immediately topped with parmesan, pine nuts, and red pepper flakes"
                ],
                cookingTime: 15,
                difficulty: "Easy",
                imageURL: "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800", // Pasta
                nutritionInfo: NutritionInfo(
                    calories: 410,
                    protein: 14.0,
                    carbs: 52.0,
                    fat: 18.0,
                    fiber: 12.0
                ),
                tags: ["Vegetarian", "Creamy", "Pasta", "Quick", "Healthy Fats"]
            )
        ]
        
        self.recipes = sampleRecipes
        print("📚 Loaded \(sampleRecipes.count) sample recipes with images")
    }
    
    private func saveFavorites() {
        do {
            let encoded = try JSONEncoder().encode(favoriteRecipes)
            UserDefaults.standard.set(encoded, forKey: "smartmeal_favorites")
            print("💾 Saved \(favoriteRecipes.count) favorite recipes")
        } catch {
            print("❌ Failed to save favorites: \(error)")
        }
    }
    
    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: "smartmeal_favorites") else {
            print("📱 No saved favorites found")
            return
        }
        
        do {
            self.favoriteRecipes = try JSONDecoder().decode([Recipe].self, from: data)
            print("📱 Loaded \(favoriteRecipes.count) favorite recipes")
        } catch {
            print("❌ Failed to load favorites: \(error)")
            self.favoriteRecipes = []
        }
    }
    
}
