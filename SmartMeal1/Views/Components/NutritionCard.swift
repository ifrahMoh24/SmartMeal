//
//  NutritionCard.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//

import SwiftUI

struct NutritionCard: View {
    let nutrition: NutritionInfo
    @State private var animateValues = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Nutrition Information")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .foregroundColor(.orange)
                    .font(.title3)
            }
            
            HStack(spacing: 16) {
                EnhancedNutritionItem(
                    label: "Calories",
                    value: "\(nutrition.calories)",
                    unit: "kcal",
                    color: .orange,
                    icon: "flame.fill",
                    animate: animateValues
                )
                
                EnhancedNutritionItem(
                    label: "Protein",
                    value: String(format: "%.1f", nutrition.protein),
                    unit: "g",
                    color: .red,
                    icon: "bolt.fill",
                    animate: animateValues
                )
                
                EnhancedNutritionItem(
                    label: "Carbs",
                    value: String(format: "%.1f", nutrition.carbs),
                    unit: "g",
                    color: .blue,
                    icon: "leaf.fill",
                    animate: animateValues
                )
                
                EnhancedNutritionItem(
                    label: "Fat",
                    value: String(format: "%.1f", nutrition.fat),
                    unit: "g",
                    color: .yellow,
                    icon: "drop.fill",
                    animate: animateValues
                )
            }
            
            // Fiber section
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.green)
                    .font(.caption)
                
                Text("Fiber")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(String(format: "%.1f", nutrition.fiber))g")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green.opacity(0.1))
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .onAppear {
            withAnimation(.spring().delay(0.3)) {
                animateValues = true
            }
        }
    }
}

struct EnhancedNutritionItem: View {
    let label: String
    let value: String
    let unit: String
    let color: Color
    let icon: String
    let animate: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 45, height: 45)
                    .scaleEffect(animate ? 1 : 0.8)
                    .animation(.spring().delay(0.1), value: animate)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .scaleEffect(animate ? 1 : 0)
                    .animation(.spring().delay(0.2), value: animate)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .opacity(animate ? 1 : 0)
            .animation(.easeInOut.delay(0.3), value: animate)
        }
        .frame(maxWidth: .infinity)
    }
}
