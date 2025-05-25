//
//  ImageAnalyzer.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import UIKit

class ImageAnalyzer: ObservableObject {
    @Published var detectedIngredients: [DetectedIngredient] = []
    @Published var isAnalyzing = false
    @Published var analysisError: String?

    func analyzeImage(_ image: UIImage) async {
        DispatchQueue.main.async {
            self.isAnalyzing = true
            self.analysisError = nil
        }

        do {
            let ingredients = try await performImageAnalysis(image)

            DispatchQueue.main.async {
                self.detectedIngredients = ingredients
                self.isAnalyzing = false
            }
        } catch {
            DispatchQueue.main.async {
                self.analysisError = error.localizedDescription
                self.isAnalyzing = false
            }
        }
    }

    private func performImageAnalysis(_ image: UIImage) async throws -> [DetectedIngredient] {
        return [
            DetectedIngredient(name: "Tomato", confidence: 0.95, boundingBox: nil),
            DetectedIngredient(name: "Onion", confidence: 0.88, boundingBox: nil),
            DetectedIngredient(name: "Garlic", confidence: 0.75, boundingBox: nil)
        ]
    }
}
