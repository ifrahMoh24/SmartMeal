//
//  RecipesView.swift
//  SmartMeal1
//
//  Fixed version - Working
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    
    let filters = ["All", "Quick", "Healthy", "Vegetarian", "AI Generated"]
    
    var filteredRecipes: [Recipe] {
        var recipes = recipeManager.recipes
        
        if !searchText.isEmpty {
            recipes = recipes.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.joined().localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedFilter != "All" {
            recipes = recipes.filter { $0.tags.contains(selectedFilter) }
        }
        
        return recipes
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Stats Header
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        VStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(.blue)
                            Text("\(recipeManager.recipes.count)")
                                .font(.headline)
                            Text("Total")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        VStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("\(recipeManager.favoriteRecipes.count)")
                                .font(.headline)
                            Text("Favorites")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        VStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.green)
                            Text("\(recipeManager.recipes.filter { $0.cookingTime < 30 }.count)")
                                .font(.headline)
                            Text("Quick")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color(.systemGroupedBackground))
                
                // Search and Filters
                VStack(spacing: 12) {
                    SearchBar(text: $searchText)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(filters, id: \.self) { filter in
                                FilterChipView(
                                    title: filter,
                                    isSelected: selectedFilter == filter
                                ) {
                                    selectedFilter = filter
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Color(.systemBackground))
                
                // Recipe List
                if filteredRecipes.isEmpty {
                    EmptyRecipesView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCard(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Recipes")
        }
    }
}

// MARK: - Supporting Views

struct FilterChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.orange : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct EmptyRecipesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No recipes found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Try scanning some ingredients to generate new recipes!")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    RecipesView()
        .environmentObject(RecipeManager())
}
