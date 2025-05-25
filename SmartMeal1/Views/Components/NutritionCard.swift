//
//  NutritionCard.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import SwiftUI

struct NutritionCard: View {
    let nutrition: NutritionInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutrition Information")
                .font(.headline)

            HStack(spacing: 20) {
                NutritionItem(label: "Calories", value: "\(nutrition.calories)", unit: "kcal")
                NutritionItem(label: "Protein", value: String(format: "%.1f", nutrition.protein), unit: "g")
                NutritionItem(label: "Carbs", value: String(format: "%.1f", nutrition.carbs), unit: "g")
                NutritionItem(label: "Fat", value: String(format: "%.1f", nutrition.fat), unit: "g")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct NutritionItem: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.orange)

            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)

            Text(label)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}
