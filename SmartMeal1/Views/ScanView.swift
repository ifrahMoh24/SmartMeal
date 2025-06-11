// Enhanced ScanView.swift - REPLACE YOUR EXISTING SCANVIEW
import SwiftUI
import PhotosUI

struct ScanView: View {
    @EnvironmentObject var imageAnalyzer: ImageAnalyzer
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @State private var showingRecipeGeneration = false
    @State private var selectedInputMethod = 0
    @State private var manualIngredients: [String] = []
    @State private var newIngredientText = ""
    @State private var showingSuccessAlert = false
    @State private var animateButtons = false
    
    let commonIngredients = [
        ("🍅", "Tomato"), ("🧅", "Onion"), ("🧄", "Garlic"), ("🫑", "Bell Pepper"),
        ("🥕", "Carrot"), ("🥔", "Potato"), ("🐔", "Chicken"), ("🥩", "Beef"),
        ("🍚", "Rice"), ("🍝", "Pasta"), ("🧀", "Cheese"), ("🥚", "Eggs"),
        ("🥬", "Lettuce"), ("🥒", "Cucumber"), ("🍄", "Mushroom"), ("🥦", "Broccoli")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with gradient
                headerSection
                
                // Input Method Selector
                inputMethodSelector
                
                // Content based on selected method
                ScrollView {
                    VStack(spacing: 24) {
                        switch selectedInputMethod {
                        case 0: cameraInputSection
                        case 1: manualInputSection
                        case 2: quickSelectSection
                        default: cameraInputSection
                        }
                        
                        // Show all collected ingredients
                        if !getAllIngredients().isEmpty {
                            allIngredientsSection
                                .transition(.opacity.combined(with: .scale))
                        }
                        
                        // Generate Recipe Button
                        if !getAllIngredients().isEmpty {
                            generateRecipeButton
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Add Ingredients")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Clear All Ingredients") {
                            withAnimation(.spring()) {
                                clearAllIngredients()
                            }
                        }
                        Button("Quick Demo") {
                            withAnimation(.easeInOut) {
                                addDemoIngredients()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.orange)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                    .onDisappear { handleImageSelection() }
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                    .onDisappear { handleImageSelection() }
            }
            .sheet(isPresented: $showingRecipeGeneration) {
                if let latestRecipe = recipeManager.recipes.last {
                    RecipeDetailView(recipe: latestRecipe)
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No recipes generated yet")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Button("Close") {
                            showingRecipeGeneration = false
                        }
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .alert("Recipes Generated! 🎉", isPresented: $showingSuccessAlert) {
                Button("View Recipes") { showingRecipeGeneration = true }
                Button("Add More", role: .cancel) { }
            } message: {
                Text("Successfully created delicious recipes from your ingredients!")
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                    animateButtons = true
                }
            }
        }
    }
    
    // MARK: - Header Section
    var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Smart Ingredient")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Detection & Recipe Generation")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text("🧠")
                            .font(.system(size: 30))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Stats Row
            HStack(spacing: 20) {
                StatItem(value: "\(getAllIngredients().count)", label: "Ingredients", icon: "leaf.fill")
                StatItem(value: "\(recipeManager.recipes.count)", label: "Recipes", icon: "book.fill")
                StatItem(value: "\(recipeManager.favoriteRecipes.count)", label: "Favorites", icon: "heart.fill")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.red.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: - Input Method Selector
    var inputMethodSelector: some View {
        Picker("Input Method", selection: $selectedInputMethod) {
            HStack {
                Image(systemName: "camera.viewfinder")
                Text("Camera")
            }.tag(0)
            
            HStack {
                Image(systemName: "pencil")
                Text("Manual")
            }.tag(1)
            
            HStack {
                Image(systemName: "hand.tap")
                Text("Quick")
            }.tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Camera Input Section
    var cameraInputSection: some View {
        VStack(spacing: 24) {
            // Header with icon
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.orange)
                }
                .scaleEffect(animateButtons ? 1.0 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateButtons)
                
                VStack(spacing: 8) {
                    Text("AI-Powered Detection")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Scan ingredients with your camera for instant recognition")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            // Action buttons
            VStack(spacing: 16) {
                Button(action: {
                    hapticFeedback()
                    showingCamera = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.title2)
                        Text("Take Photo")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .scaleEffect(animateButtons ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateButtons)

                Button(action: {
                    hapticFeedback()
                    showingImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                            .font(.title2)
                        Text("Choose from Gallery")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                }
                .scaleEffect(animateButtons ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateButtons)
            }

            // Selected image preview
            if let image = selectedImage {
                VStack(spacing: 16) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    if imageAnalyzer.isAnalyzing {
                        HStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Analyzing ingredients...")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("AI processing in progress")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
                .transition(.opacity.combined(with: .scale))
            }

            // Analysis results
            if !imageAnalyzer.detectedIngredients.isEmpty && !imageAnalyzer.isAnalyzing {
                detectedIngredientsView
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .bottom)),
                        removal: .opacity
                    ))
            }
        }
    }
    
    // MARK: - Manual Input Section
    var manualInputSection: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "text.cursor")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.blue)
                }
                
                VStack(spacing: 8) {
                    Text("Manual Entry")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Type ingredient names for precise control")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            // Input field
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    TextField("Enter ingredient name", text: $newIngredientText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit { addManualIngredient() }
                    
                    Button("Add") {
                        addManualIngredient()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(newIngredientText.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(newIngredientText.isEmpty)
                }
                
                if !manualIngredients.isEmpty {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                        ForEach(manualIngredients.indices, id: \.self) { index in
                            HStack {
                                Text(manualIngredients[index])
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                Button(action: {
                                    manualIngredients.remove(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
    
    // MARK: - Quick Select Section
    var quickSelectSection: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "hand.tap")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.green)
                }
                
                VStack(spacing: 8) {
                    Text("Quick Selection")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Tap common ingredients for instant addition")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            // Ingredient grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                ForEach(Array(commonIngredients.enumerated()), id: \.offset) { index, ingredient in
                    QuickSelectButton(
                        emoji: ingredient.0,
                        name: ingredient.1,
                        isSelected: manualIngredients.contains(ingredient.1),
                        animationDelay: Double(index) * 0.05
                    ) {
                        hapticFeedback()
                        toggleQuickSelectIngredient(ingredient.1)
                    }
                }
            }
        }
    }
    
    // MARK: - Supporting Views
    var detectedIngredientsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain")
                    .foregroundColor(.orange)
                    .font(.title2)
                
                Text("AI Detection Results")
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                ForEach(imageAnalyzer.detectedIngredients) { ingredient in
                    VStack(spacing: 8) {
                        Text(ingredient.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 4) {
                            ForEach(0..<5) { i in
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(i < Int(ingredient.confidence * 5) ? .yellow : .gray.opacity(0.3))
                            }
                            
                            Text("\(Int(ingredient.confidence * 100))%")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(12)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    var allIngredientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "list.bullet")
                    .foregroundColor(.orange)
                    .font(.title2)
                
                Text("Your Ingredients (\(getAllIngredients().count))")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Ready to cook!")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                ForEach(getAllIngredients(), id: \.self) { ingredient in
                    Text(ingredient)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.15))
                        .foregroundColor(.orange)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    var generateRecipeButton: some View {
        Button(action: generateRecipes) {
            HStack(spacing: 12) {
                if recipeManager.isLoading {
                    ProgressView()
                        .scaleEffect(0.9)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "wand.and.stars")
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(recipeManager.isLoading ? "Creating Magic..." : "Generate Recipes")
                        .fontWeight(.bold)
                        .font(.headline)
                    
                    Text("AI-powered recipe generation")
                        .font(.caption)
                        .opacity(0.9)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .opacity(recipeManager.isLoading ? 0.6 : 1.0)
            }
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.red]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .orange.opacity(0.4), radius: 12, x: 0, y: 8)
            .scaleEffect(recipeManager.isLoading ? 0.98 : 1.0)
        }
        .disabled(recipeManager.isLoading)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: recipeManager.isLoading)
    }
    
    // MARK: - Helper Functions
    private func getAllIngredients() -> [String] {
        var allIngredients = manualIngredients
        allIngredients.append(contentsOf: imageAnalyzer.detectedIngredients.map { $0.name })
        return Array(Set(allIngredients)).sorted()
    }
    
    private func addManualIngredient() {
        let trimmed = newIngredientText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && !manualIngredients.contains(trimmed) {
            withAnimation(.spring()) {
                manualIngredients.append(trimmed)
            }
            newIngredientText = ""
        }
    }
    
    private func toggleQuickSelectIngredient(_ ingredient: String) {
        withAnimation(.spring()) {
            if manualIngredients.contains(ingredient) {
                manualIngredients.removeAll { $0 == ingredient }
            } else {
                manualIngredients.append(ingredient)
            }
        }
    }
    
    private func clearAllIngredients() {
        manualIngredients.removeAll()
        imageAnalyzer.detectedIngredients.removeAll()
        selectedImage = nil
    }
    
    private func addDemoIngredients() {
        manualIngredients = ["Tomato", "Onion", "Garlic", "Bell Pepper"]
    }
    
    private func handleImageSelection() {
        if let image = selectedImage {
            Task {
                await imageAnalyzer.analyzeImage(image)
            }
        }
    }
    
    private func generateRecipes() {
        let ingredients = getAllIngredients()
        Task {
            await recipeManager.generateRecipeFromIngredients(ingredients)
            await MainActor.run {
                showingSuccessAlert = true
            }
        }
    }
    
    private func hapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

// MARK: - Supporting Components

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.15))
        .cornerRadius(10)
    }
}

struct QuickSelectButton: View {
    let emoji: String
    let name: String
    let isSelected: Bool
    let animationDelay: Double
    let action: () -> Void
    
    @State private var isVisible = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 32))
                
                Text(name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 90, height: 90)
            .background(
                isSelected
                ? Color.green.opacity(0.2)
                : Color.gray.opacity(0.1)
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected
                        ? Color.green
                        : Color.gray.opacity(0.3),
                        lineWidth: 2
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? Color.green.opacity(0.3) : Color.clear,
                radius: isSelected ? 8 : 0,
                x: 0,
                y: isSelected ? 4 : 0
            )
        }
        .foregroundColor(.primary)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(animationDelay), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}
