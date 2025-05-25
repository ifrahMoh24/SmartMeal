//
//  UserProfile.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import Foundation

struct UserProfile: Codable {
    var name: String
    var dietaryRestrictions: [String]
    var allergies: [String]
    var preferredCuisines: [String]
    var skillLevel: String
    var favoriteRecipes: [Recipe]
}
