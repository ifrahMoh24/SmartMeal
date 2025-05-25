// ScanView.swift
import SwiftUI
import PhotosUI

struct ScanView: View {
    @EnvironmentObject var imageAnalyzer: ImageAnalyzer
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @State private var showingRecipeGeneration = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Camera/Gallery buttons
                VStack(spacing: 16) {
                    Button(action: { showingCamera = true }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Take Photo")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                    }

                    Button(action: { showingImagePicker = true }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Choose from Gallery")
                        }
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal)

                // Selected image preview
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                // Analysis results
                if imageAnalyzer.isAnalyzing {
                    ProgressView("Analyzing ingredients...")
                        .padding()
                } else if !imageAnalyzer.detectedIngredients.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Detected Ingredients:")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                            ForEach(imageAnalyzer.detectedIngredients) { ingredient in
                                VStack {
                                    Text(ingredient.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    Text("\(Int(ingredient.confidence * 100))%")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .padding(8)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)

                        Button("Generate Recipe") {
                            let ingredients = imageAnalyzer.detectedIngredients.map { $0.name }
                            Task {
                                await recipeManager.generateRecipeFromIngredients(ingredients)
                                showingRecipeGeneration = true
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .navigationTitle("Ingredient Scanner")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                    .onDisappear {
                        if let image = selectedImage {
                            Task {
                                await imageAnalyzer.analyzeImage(image)
                            }
                        }
                    }
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                    .onDisappear {
                        if let image = selectedImage {
                            Task {
                                await imageAnalyzer.analyzeImage(image)
                            }
                        }
                    }
            }
            .sheet(isPresented: $showingRecipeGeneration) {
                RecipeDetailViewWrapper()
            }
        }
    }
}

// Wrapper view to avoid type-checking issue
struct RecipeDetailViewWrapper: View {
    @EnvironmentObject var recipeManager: RecipeManager

    var body: some View {
        if let latestRecipe = recipeManager.recipes.last {
            RecipeDetailView(recipe: latestRecipe)
        } else {
            Text("No recipe to display")
        }
    }
}
