//
//  ProfileView.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import SwiftUI

struct ProfileView: View {
    @State private var userProfile = UserProfile(
        name: "John Doe",
        dietaryRestrictions: ["Vegetarian"],
        allergies: ["Nuts"],
        preferredCuisines: ["Italian", "Mediterranean"],
        skillLevel: "Intermediate",
        favoriteRecipes: []
    )
    @EnvironmentObject var recipeManager: RecipeManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.orange.gradient)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(String(userProfile.name.prefix(1)))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )

                        Text(userProfile.name)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Cooking Level: \(userProfile.skillLevel)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()

                    HStack(spacing: 20) {
                        StatCard(
                            title: "Recipes",
                            value: "\(recipeManager.recipes.count)",
                            icon: "book"
                        )

                        StatCard(
                            title: "Favorites",
                            value: "\(recipeManager.favoriteRecipes.count)",
                            icon: "heart.fill"
                        )

                        StatCard(
                            title: "Cooked",
                            value: "12",
                            icon: "checkmark.circle.fill"
                        )
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Preferences")
                            .font(.headline)
                            .padding(.horizontal)

                        PreferenceSection(
                            title: "Dietary Restrictions",
                            items: userProfile.dietaryRestrictions,
                            color: .green
                        )

                        PreferenceSection(
                            title: "Allergies",
                            items: userProfile.allergies,
                            color: .red
                        )

                        PreferenceSection(
                            title: "Preferred Cuisines",
                            items: userProfile.preferredCuisines,
                            color: .blue
                        )
                    }

                    if !recipeManager.favoriteRecipes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Favorite Recipes")
                                .font(.headline)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(recipeManager.favoriteRecipes.prefix(5)) { recipe in
                                        CompactRecipeCard(recipe: recipe)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        // Edit action
                    }
                }
            }
        }
    }
}
