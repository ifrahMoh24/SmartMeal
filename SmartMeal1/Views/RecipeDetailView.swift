//
//  RecipeDetailView.swift
//  SmartMeal1
//
//  Enhanced with modern UI, cooking timer, and better layout
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var isFavorite = false
    @State private var showingCookingTimer = false
    @State private var showingShareSheet = false
    @State private var showingNutritionDetail = false
    @State private var completedSteps: Set<Int> = []
    @State private var showingIngredientDetail = false
    @State private var selectedIngredients: Set<String> = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image Section
                heroImageSection
                
                // Recipe Content
                VStack(spacing: 24) {
                    // Title and basic info
                    titleSection
                    
                    // Action buttons
                    actionButtonsSection
                    
                    // Quick stats
                    quickStatsSection
                    
                    // Nutrition info (if available)
                    if let nutrition = recipe.nutritionInfo {
                        nutritionSection(nutrition)
                    }
                    
                    // Ingredients section
                    ingredientsSection
                    
                    // Instructions section
                    instructionsSection
                    
                    // Tags section
                    if !recipe.tags.isEmpty {
                        tagsSection
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.orange)
                    }
                    
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .orange)
                    }
                }
            }
        }
        .onAppear {
            isFavorite = recipeManager.isFavorite(recipe)
        }
        .sheet(isPresented: $showingCookingTimer) {
            CookingTimerView(recipe: recipe)
        }
        .sheet(isPresented: $showingNutritionDetail) {
            if let nutrition = recipe.nutritionInfo {
                NutritionDetailView(nutrition: nutrition, recipeName: recipe.title)
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(recipe: recipe)
        }
    }
    
    // MARK: - Hero Image Section
    var heroImageSection: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: recipe.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange.opacity(0.4), Color.red.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            Text("Recipe Image")
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                    )
            }
            .frame(height: 280)
            .clipped()
            
            // Gradient overlay for text readability
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 280)
            
            // Difficulty badge
            HStack {
                Text(recipe.difficulty)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(difficultyColor)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Title Section
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            Text("A delicious recipe that combines fresh ingredients with amazing flavors")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Action Buttons
    var actionButtonsSection: some View {
        HStack(spacing: 12) {
            Button(action: { showingCookingTimer = true }) {
                HStack {
                    Image(systemName: "timer")
                    Text("Start Cooking")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .cornerRadius(12)
            }
            
            Button(action: toggleFavorite) {
                HStack {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                    Text(isFavorite ? "Saved" : "Save")
                }
                .font(.headline)
                .foregroundColor(isFavorite ? .red : .orange)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Quick Stats
    var quickStatsSection: some View {
        HStack(spacing: 20) {
            QuickStatItem(
                icon: "clock.fill",
                title: "Cook Time",
                value: "\(recipe.cookingTime) min",
                color: .blue
            )
            
            QuickStatItem(
                icon: "person.2.fill",
                title: "Servings",
                value: "4",
                color: .green
            )
            
            if let nutrition = recipe.nutritionInfo {
                QuickStatItem(
                    icon: "flame.fill",
                    title: "Calories",
                    value: "\(nutrition.calories)",
                    color: .orange
                )
            }
            
            QuickStatItem(
                icon: "star.fill",
                title: "Rating",
                value: "4.5",
                color: .yellow
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    // MARK: - Nutrition Section
    func nutritionSection(_ nutrition: NutritionInfo) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                                  
                                  Text("Nutrition Information")
                                      .font(.headline)
                                      .fontWeight(.semibold)
                                  
                                  Spacer()
                                  
                                  Button("Details") {
                                      showingNutritionDetail = true
                                  }
                                  .font(.caption)
                                  .foregroundColor(.green)
                                  .padding(.horizontal, 12)
                                  .padding(.vertical, 6)
                                  .background(Color.green.opacity(0.1))
                                  .cornerRadius(12)
                              }
                              
                              HStack(spacing: 16) {
                                  NutritionItem(
                                      label: "Protein",
                                      value: String(format: "%.1f", nutrition.protein),
                                      unit: "g",
                                      color: .red,
                                      percentage: nutrition.protein / 50.0
                                  )
                                  
                                  NutritionItem(
                                      label: "Carbs",
                                      value: String(format: "%.1f", nutrition.carbs),
                                      unit: "g",
                                      color: .blue,
                                      percentage: nutrition.carbs / 300.0
                                  )
                                  
                                  NutritionItem(
                                      label: "Fat",
                                      value: String(format: "%.1f", nutrition.fat),
                                      unit: "g",
                                      color: .yellow,
                                      percentage: nutrition.fat / 65.0
                                  )
                                  
                                  NutritionItem(
                                      label: "Fiber",
                                      value: String(format: "%.1f", nutrition.fiber),
                                      unit: "g",
                                      color: .green,
                                      percentage: nutrition.fiber / 25.0
                                  )
                              }
                          }
                          .padding()
                          .background(Color(.systemBackground))
                          .cornerRadius(16)
                          .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                      }
                      
                      // MARK: - Ingredients Section
                      var ingredientsSection: some View {
                          VStack(alignment: .leading, spacing: 16) {
                              HStack {
                                  Image(systemName: "list.bullet")
                                      .foregroundColor(.orange)
                                      .font(.title2)
                                  
                                  Text("Ingredients (\(recipe.ingredients.count))")
                                      .font(.headline)
                                      .fontWeight(.semibold)
                                  
                                  Spacer()
                                  
                                  Text("\(selectedIngredients.count)/\(recipe.ingredients.count) checked")
                                      .font(.caption)
                                      .foregroundColor(.secondary)
                              }
                              
                              VStack(spacing: 12) {
                                  ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                                      IngredientRow(
                                          ingredient: ingredient,
                                          isSelected: selectedIngredients.contains(ingredient),
                                          onToggle: {
                                              if selectedIngredients.contains(ingredient) {
                                                  selectedIngredients.remove(ingredient)
                                              } else {
                                                  selectedIngredients.insert(ingredient)
                                              }
                                          }
                                      )
                                  }
                              }
                          }
                          .padding()
                          .background(Color(.systemBackground))
                          .cornerRadius(16)
                          .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                      }
                      
                      // MARK: - Instructions Section
                      var instructionsSection: some View {
                          VStack(alignment: .leading, spacing: 16) {
                              HStack {
                                  Image(systemName: "list.number")
                                      .foregroundColor(.blue)
                                      .font(.title2)
                                  
                                  Text("Instructions")
                                      .font(.headline)
                                      .fontWeight(.semibold)
                                  
                                  Spacer()
                                  
                                  Text("\(completedSteps.count)/\(recipe.instructions.count) completed")
                                      .font(.caption)
                                      .foregroundColor(.secondary)
                              }
                              
                              VStack(spacing: 16) {
                                  ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                                      InstructionStep(
                                          stepNumber: index + 1,
                                          instruction: instruction,
                                          isCompleted: completedSteps.contains(index),
                                          onToggle: {
                                              if completedSteps.contains(index) {
                                                  completedSteps.remove(index)
                                              } else {
                                                  completedSteps.insert(index)
                                                  let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                                  impactFeedback.impactOccurred()
                                              }
                                          }
                                      )
                                  }
                              }
                          }
                          .padding()
                          .background(Color(.systemBackground))
                          .cornerRadius(16)
                          .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                      }
                      
                      // MARK: - Tags Section
                      var tagsSection: some View {
                          VStack(alignment: .leading, spacing: 12) {
                              HStack {
                                  Image(systemName: "tag.fill")
                                      .foregroundColor(.purple)
                                      .font(.title2)
                                  
                                  Text("Recipe Tags")
                                      .font(.headline)
                                      .fontWeight(.semibold)
                              }
                              
                              FlowLayout(spacing: 8) {
                                  ForEach(recipe.tags, id: \.self) { tag in
                                      Text(tag)
                                          .font(.subheadline)
                                          .padding(.horizontal, 12)
                                          .padding(.vertical, 6)
                                          .background(tagColor(for: tag))
                                          .foregroundColor(.white)
                                          .cornerRadius(16)
                                  }
                              }
                          }
                          .padding()
                          .background(Color(.systemBackground))
                          .cornerRadius(16)
                          .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                      }
                      
                      // MARK: - Helper Properties
                      private var difficultyColor: Color {
                          switch recipe.difficulty.lowercased() {
                          case "easy": return .green
                          case "medium": return .orange
                          case "hard": return .red
                          default: return .gray
                          }
                      }
                      
                      private func tagColor(for tag: String) -> Color {
                          switch tag.lowercased() {
                          case "healthy": return .green
                          case "quick": return .blue
                          case "vegetarian": return .green
                          case "spicy": return .red
                          case "ai generated": return .purple
                          default: return .orange
                          }
                      }
                      
                      // MARK: - Actions
                      private func toggleFavorite() {
                          let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                          impactFeedback.impactOccurred()
                          
                          withAnimation(.spring()) {
                              isFavorite.toggle()
                              if isFavorite {
                                  recipeManager.addToFavorites(recipe)
                              } else {
                                  recipeManager.removeFromFavorites(recipe)
                              }
                          }
                      }
                  }

                  // MARK: - Supporting Views

                  struct QuickStatItem: View {
                      let icon: String
                      let title: String
                      let value: String
                      let color: Color
                      
                      var body: some View {
                          VStack(spacing: 8) {
                              Image(systemName: icon)
                                  .font(.title2)
                                  .foregroundColor(color)
                              
                              Text(value)
                                  .font(.headline)
                                  .fontWeight(.bold)
                                  .foregroundColor(.primary)
                              
                              Text(title)
                                  .font(.caption)
                                  .foregroundColor(.secondary)
                          }
                          .frame(maxWidth: .infinity)
                      }
                  }

                  struct NutritionItem: View {
                      let label: String
                      let value: String
                      let unit: String
                      let color: Color
                      let percentage: Double
                      
                      var body: some View {
                          VStack(spacing: 8) {
                              ZStack {
                                  Circle()
                                      .stroke(color.opacity(0.2), lineWidth: 4)
                                      .frame(width: 50, height: 50)
                                  
                                  Circle()
                                      .trim(from: 0, to: min(percentage, 1.0))
                                      .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                      .frame(width: 50, height: 50)
                                      .rotationEffect(.degrees(-90))
                                  
                                  VStack(spacing: 1) {
                                      Text(value)
                                          .font(.caption)
                                          .fontWeight(.bold)
                                      Text(unit)
                                          .font(.caption2)
                                          .foregroundColor(.secondary)
                                  }
                              }
                              
                              Text(label)
                                  .font(.caption)
                                  .fontWeight(.medium)
                                  .foregroundColor(.secondary)
                          }
                          .frame(maxWidth: .infinity)
                      }
                  }

                  struct IngredientRow: View {
                      let ingredient: String
                      let isSelected: Bool
                      let onToggle: () -> Void
                      
                      var body: some View {
                          HStack(spacing: 12) {
                              Button(action: onToggle) {
                                  Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                      .font(.title2)
                                      .foregroundColor(isSelected ? .green : .gray)
                              }
                              
                              Text("• \(ingredient)")
                                  .font(.subheadline)
                                  .strikethrough(isSelected)
                                  .foregroundColor(isSelected ? .secondary : .primary)
                              
                              Spacer()
                          }
                          .padding(.vertical, 4)
                          .contentShape(Rectangle())
                          .onTapGesture {
                              onToggle()
                          }
                      }
                  }

                  struct InstructionStep: View {
                      let stepNumber: Int
                      let instruction: String
                      let isCompleted: Bool
                      let onToggle: () -> Void
                      
                      var body: some View {
                          HStack(alignment: .top, spacing: 12) {
                              Button(action: onToggle) {
                                  ZStack {
                                      Circle()
                                          .fill(isCompleted ? Color.green : Color.blue.opacity(0.1))
                                          .frame(width: 32, height: 32)
                                      
                                      if isCompleted {
                                          Image(systemName: "checkmark")
                                              .font(.caption)
                                              .fontWeight(.bold)
                                              .foregroundColor(.white)
                                      } else {
                                          Text("\(stepNumber)")
                                              .font(.caption)
                                              .fontWeight(.bold)
                                              .foregroundColor(.blue)
                                      }
                                  }
                              }
                              
                              VStack(alignment: .leading, spacing: 4) {
                                  Text("Step \(stepNumber)")
                                      .font(.caption)
                                      .fontWeight(.semibold)
                                      .foregroundColor(.secondary)
                                  
                                  Text(instruction)
                                      .font(.subheadline)
                                      .strikethrough(isCompleted)
                                      .foregroundColor(isCompleted ? .secondary : .primary)
                                      .fixedSize(horizontal: false, vertical: true)
                              }
                              
                              Spacer()
                          }
                          .padding()
                          .background(isCompleted ? Color.green.opacity(0.05) : Color.blue.opacity(0.05))
                          .cornerRadius(12)
                          .overlay(
                              RoundedRectangle(cornerRadius: 12)
                                  .stroke(isCompleted ? Color.green.opacity(0.3) : Color.blue.opacity(0.3), lineWidth: 1)
                          )
                      }
                  }

                  // MARK: - Additional Modal Views

                  struct CookingTimerView: View {
                      let recipe: Recipe
                      @Environment(\.dismiss) private var dismiss
                      @State private var timeRemaining: Int
                      @State private var isTimerRunning = false
                      @State private var timer: Timer?
                      
                      init(recipe: Recipe) {
                          self.recipe = recipe
                          self._timeRemaining = State(initialValue: recipe.cookingTime * 60)
                      }
                      
                      var body: some View {
                          NavigationView {
                              VStack(spacing: 30) {
                                  Text(recipe.title)
                                      .font(.title2)
                                      .fontWeight(.semibold)
                                      .multilineTextAlignment(.center)
                                      .padding(.horizontal)
                                  
                                  ZStack {
                                      Circle()
                                          .stroke(Color.orange.opacity(0.2), lineWidth: 20)
                                          .frame(width: 250, height: 250)
                                      
                                      Circle()
                                          .trim(from: 0, to: progress)
                                          .stroke(Color.orange, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                          .frame(width: 250, height: 250)
                                          .rotationEffect(.degrees(-90))
                                          .animation(.linear(duration: 1), value: progress)
                                      
                                      VStack(spacing: 8) {
                                          Text(timeString)
                                              .font(.system(size: 48, weight: .bold, design: .monospaced))
                                              .foregroundColor(.orange)
                                          
                                          Text("remaining")
                                              .font(.headline)
                                              .foregroundColor(.secondary)
                                      }
                                  }
                                  
                                  HStack(spacing: 20) {
                                      Button(action: resetTimer) {
                                          Image(systemName: "arrow.counterclockwise")
                                              .font(.title2)
                                              .foregroundColor(.gray)
                                              .padding()
                                              .background(Color.gray.opacity(0.1))
                                              .cornerRadius(50)
                                      }
                                      
                                      Button(action: toggleTimer) {
                                          Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                                              .font(.title)
                                              .foregroundColor(.white)
                                              .padding(20)
                                              .background(Color.orange)
                                              .cornerRadius(50)
                                      }
                                      
                                      Button(action: addTime) {
                                          Image(systemName: "plus")
                                              .font(.title2)
                                              .foregroundColor(.orange)
                                              .padding()
                                              .background(Color.orange.opacity(0.1))
                                              .cornerRadius(50)
                                      }
                                  }
                                  
                                  Spacer()
                              }
                              .padding()
                              .navigationTitle("Cooking Timer")
                              .navigationBarTitleDisplayMode(.inline)
                              .toolbar {
                                  ToolbarItem(placement: .navigationBarTrailing) {
                                      Button("Done") {
                                          timer?.invalidate()
                                          dismiss()
                                      }
                                  }
                              }
                          }
                          .onDisappear {
                              timer?.invalidate()
                          }
                      }
                      
                      private var progress: Double {
                          let totalTime = recipe.cookingTime * 60
                          return Double(totalTime - timeRemaining) / Double(totalTime)
                      }
                      
                      private var timeString: String {
                          let minutes = timeRemaining / 60
                          let seconds = timeRemaining % 60
                          return String(format: "%02d:%02d", minutes, seconds)
                      }
                      
                      private func toggleTimer() {
                          if isTimerRunning {
                              timer?.invalidate()
                              timer = nil
                          } else {
                              timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                  if timeRemaining > 0 {
                                      timeRemaining -= 1
                                  } else {
                                      timer?.invalidate()
                                      timer = nil
                                      isTimerRunning = false
                                  }
                              }
                          }
                          isTimerRunning.toggle()
                      }
                      
                      private func resetTimer() {
                          timer?.invalidate()
                          timer = nil
                          isTimerRunning = false
                          timeRemaining = recipe.cookingTime * 60
                      }
                      
                      private func addTime() {
                          timeRemaining += 300
                      }
                  }

                  struct NutritionDetailView: View {
                      let nutrition: NutritionInfo
                      let recipeName: String
                      @Environment(\.dismiss) private var dismiss
                      
                      var body: some View {
                          NavigationView {
                              ScrollView {
                                  VStack(spacing: 24) {
                                      VStack(spacing: 12) {
                                          Text("\(nutrition.calories)")
                                              .font(.system(size: 48, weight: .bold))
                                              .foregroundColor(.orange)
                                          
                                          Text("Calories per serving")
                                              .font(.headline)
                                              .foregroundColor(.secondary)
                                      }
                                      .padding()
                                      .background(Color.orange.opacity(0.1))
                                      .cornerRadius(16)
                                      
                                      VStack(spacing: 16) {
                                          DetailedNutritionRow(label: "Protein", value: nutrition.protein, unit: "g", color: .red, dailyValue: 20)
                                          DetailedNutritionRow(label: "Carbohydrates", value: nutrition.carbs, unit: "g", color: .blue, dailyValue: 15)
                                          DetailedNutritionRow(label: "Total Fat", value: nutrition.fat, unit: "g", color: .yellow, dailyValue: 18)
                                          DetailedNutritionRow(label: "Dietary Fiber", value: nutrition.fiber, unit: "g", color: .green, dailyValue: 30)
                                      }
                                      .padding()
                                      .background(Color(.systemBackground))
                                      .cornerRadius(16)
                                      .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                                  }
                                  .padding()
                              }
                              .navigationTitle("Nutrition Facts")
                              .navigationBarTitleDisplayMode(.inline)
                              .toolbar {
                                  ToolbarItem(placement: .navigationBarTrailing) {
                                      Button("Done") {
                                          dismiss()
                                      }
                                  }
                              }
                          }
                      }
                  }

                  struct DetailedNutritionRow: View {
                      let label: String
                      let value: Double
                      let unit: String
                      let color: Color
                      let dailyValue: Int
                      
                      var body: some View {
                          HStack {
                              VStack(alignment: .leading, spacing: 4) {
                                  Text(label)
                                      .font(.subheadline)
                                      .fontWeight(.medium)
                                  
                                  Text("\(dailyValue)% Daily Value")
                                      .font(.caption)
                                      .foregroundColor(.secondary)
                              }
                              
                              Spacer()
                              
                              Text("\(String(format: "%.1f", value))\(unit)")
                                  .font(.headline)
                                  .fontWeight(.semibold)
                                  .foregroundColor(color)
                          }
                          .padding()
                          .background(color.opacity(0.1))
                          .cornerRadius(12)
                      }
                  }

                  struct ShareSheet: View {
                      let recipe: Recipe
                      @Environment(\.dismiss) private var dismiss
                      
                      var body: some View {
                          NavigationView {
                              VStack(spacing: 20) {
                                  Text("Share \(recipe.title)")
                                      .font(.title2)
                                      .fontWeight(.semibold)
                                      .padding()
                                  
                                  VStack(spacing: 16) {
                                      ShareButton(icon: "message.fill", title: "Messages", color: .green) {
                                          // Share via Messages
                                      }
                                      
                                      ShareButton(icon: "envelope.fill", title: "Mail", color: .blue) {
                                          // Share via Mail
                                      }
                                      
                                      ShareButton(icon: "square.and.arrow.up", title: "More Options", color: .gray) {
                                          // Show system share sheet
                                      }
                                  }
                                  .padding()
                                  
                                  Spacer()
                              }
                              .navigationTitle("Share Recipe")
                              .navigationBarTitleDisplayMode(.inline)
                              .toolbar {
                                  ToolbarItem(placement: .navigationBarTrailing) {
                                      Button("Cancel") {
                                          dismiss()
                                      }
                                  }
                              }
                          }
                      }
                  }

                  struct ShareButton: View {
                      let icon: String
                      let title: String
                      let color: Color
                      let action: () -> Void
                      
                      var body: some View {
                          Button(action: action) {
                              HStack {
                                  Image(systemName: icon)
                                      .font(.title2)
                                      .foregroundColor(color)
                                      .frame(width: 30)
                                  
                                  Text(title)
                                      .font(.headline)
                                      .foregroundColor(.primary)
                                  
                                  Spacer()
                                  
                                  Image(systemName: "chevron.right")
                                      .font(.caption)
                                      .foregroundColor(.secondary)
                              }
                              .padding()
                              .background(Color(.systemGray6))
                              .cornerRadius(12)
                          }
                      }
                  }

                  // MARK: - Flow Layout for Tags
                  struct FlowLayout: Layout {
                      let spacing: CGFloat
                      
                      init(spacing: CGFloat = 8) {
                          self.spacing = spacing
                      }
                      
                      func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
                          let result = FlowResult(
                              in: proposal.replacingUnspecifiedDimensions().width,
                              subviews: subviews,
                              spacing: spacing
                          )
                          return result.size
                      }
                      
                      func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
                          let result = FlowResult(
                              in: proposal.replacingUnspecifiedDimensions().width,
                              subviews: subviews,
                              spacing: spacing
                          )
                          for (index, subview) in subviews.enumerated() {
                              subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                                      y: bounds.minY + result.frames[index].minY),
                                           proposal: ProposedViewSize(result.frames[index].size))
                          }
                      }
                  }

                  struct FlowResult {
                      let size: CGSize
                      let frames: [CGRect]
                  }

                  extension FlowResult {
                      init(in maxWidth: CGFloat, subviews: LayoutSubviews, spacing: CGFloat) {
                          var frames: [CGRect] = []
                          var currentRow: [LayoutSubview] = []
                          var currentRowWidth: CGFloat = 0
                          var totalHeight: CGFloat = 0
                          var maxRowHeight: CGFloat = 0
                          
                          for subview in subviews {
                              let size = subview.sizeThatFits(.unspecified)
                              
                              if currentRowWidth + size.width > maxWidth && !currentRow.isEmpty {
                                  var x: CGFloat = 0
                                  for rowSubview in currentRow {
                                      let rowSize = rowSubview.sizeThatFits(.unspecified)
                                      frames.append(CGRect(x: x, y: totalHeight, width: rowSize.width, height: rowSize.height))
                                      x += rowSize.width + spacing
                                  }
                                  
                                  totalHeight += maxRowHeight + spacing
                                  currentRow.removeAll()
                                  currentRowWidth = 0
                                  maxRowHeight = 0
                              }
                              
                              currentRow.append(subview)
                              currentRowWidth += size.width + (currentRow.count > 1 ? spacing : 0)
                              maxRowHeight = max(maxRowHeight, size.height)
                          }
                          
                          var x: CGFloat = 0
                          for rowSubview in currentRow {
                              let rowSize = rowSubview.sizeThatFits(.unspecified)
                              frames.append(CGRect(x: x, y: totalHeight, width: rowSize.width, height: rowSize.height))
                              x += rowSize.width + spacing
                          }
                          
                          if !currentRow.isEmpty {
                              totalHeight += maxRowHeight
                          }
                          
                          self.frames = frames
                          self.size = CGSize(width: maxWidth, height: totalHeight)
                      }
                  }

                  #Preview {
                      NavigationView {
                          RecipeDetailView(recipe: Recipe(
                              title: "Mediterranean Quinoa Bowl",
                              ingredients: ["Quinoa", "Cherry Tomatoes", "Cucumber", "Feta Cheese"],
                              instructions: ["Cook quinoa", "Chop vegetables", "Mix everything", "Serve"],
                              cookingTime: 25,
                              difficulty: "Easy",
                              imageURL: nil,
                              nutritionInfo: NutritionInfo(calories: 385, protein: 16.5, carbs: 45.0, fat: 14.5, fiber: 8.2),
                              tags: ["Healthy", "Vegetarian", "Mediterranean"]
                          ))
                      }
                      .environmentObject(RecipeManager())
                  }
