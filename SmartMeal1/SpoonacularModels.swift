//
//  SpoonacularModels.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 11.06.2025.
//

import Foundation

// MARK: - API Models
struct SpoonacularRecipe: Codable {
    let id: Int
    let title: String
    let image: String?
    let usedIngredients: [UsedIngredient]?
    let missedIngredients: [MissedIngredient]?
}

struct UsedIngredient: Codable {
    let name: String
    let image: String?
}

struct MissedIngredient: Codable {
    let name: String
    let image: String?
}
