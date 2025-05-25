//
//  DetectedIngredient.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import Foundation
import CoreGraphics

struct DetectedIngredient: Identifiable {
    let id = UUID()
    let name: String
    let confidence: Double
    let boundingBox: CGRect?
}
