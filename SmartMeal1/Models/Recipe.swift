//
//  Recipe.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import Foundation

struct Recipe: Identifiable, Codable {
    let id = UUID()
    let title: String
    let ingredients: [String]
    let instructions: [String]
    let cookingTime: Int
    let difficulty: String
    let imageURL: String?
    let nutritionInfo: NutritionInfo?
    let tags: [String]
}
