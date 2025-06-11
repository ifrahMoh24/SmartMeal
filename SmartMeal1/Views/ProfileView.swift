//
//  ProfileView.swift
//  SmartMeal1
//
//  Enhanced with modern UI, better statistics, and achievements
//

import SwiftUI

struct ProfileView: View {
    @State private var userProfile = UserProfile(
        name: "Chef Explorer",
        dietaryRestrictions: ["Vegetarian"],
        allergies: ["Nuts"],
        preferredCuisines: ["Italian", "Mediterranean", "Asian"],
        skillLevel: "Intermediate",
        favoriteRecipes: []
    )
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var showingEditProfile = false
    @State private var showingAchievements = false
    @State private var animateStats = false
    
    var cookingStats: CookingStats {
        CookingStats(
            totalRecipes: recipeManager.recipes.count,
            favoriteRecipes: recipeManager.favoriteRecipes.count,
            quickRecipes: recipeManager.recipes.filter { $0.cookingTime <= 30 }.count,
            healthyRecipes: recipeManager.recipes.filter { $0.tags.contains("Healthy") }.count,
            weeklyGoal: 5,
            cookedThisWeek: 3
        )
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    profileHeaderSection
                    
                    // Cooking Progress
                    cookingProgressSection
                    
                    // Statistics Grid
                    statisticsSection
                    
                    // Achievements
                    achievementsSection
                    
                    // Favorite Recipes
                    if !recipeManager.favoriteRecipes.isEmpty {
                        favoriteRecipesSection
                    }
                    
                    // Preferences
                    preferencesSection
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditProfile = true
                    }
                    .foregroundColor(.orange)
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(userProfile: $userProfile)
            }
            .sheet(isPresented: $showingAchievements) {
                AchievementsView(stats: cookingStats)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
                    animateStats = true
                }
            }
        }
    }
    
    // MARK: - Profile Header
    var profileHeaderSection: some View {
        VStack(spacing: 20) {
            // Avatar and basic info
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange, Color.red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: .orange.opacity(0.3), radius: 12, x: 0, y: 8)
                    
                    VStack {
                        Text("👨‍🍳")
                            .font(.system(size: 50))
                        
                        Text(String(userProfile.name.prefix(2)).uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(animateStats ? 1.0 : 0.8)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateStats)
                
                VStack(spacing: 8) {
                    Text(userProfile.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 12) {
                        SkillLevelBadge(level: userProfile.skillLevel)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text("Member since May 2025")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Quick actions
            HStack(spacing: 16) {
                ProfileActionButton(
                    icon: "trophy.fill",
                    title: "Achievements",
                    color: .yellow
                ) {
                    showingAchievements = true
                }
                
                ProfileActionButton(
                    icon: "heart.fill",
                    title: "Favorites",
                    color: .red
                ) {
                    // Navigate to favorites
                }
                
                ProfileActionButton(
                    icon: "calendar",
                    title: "Meal Plan",
                    color: .blue
                ) {
                    // Navigate to meal planning
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Cooking Progress
    var cookingProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "target")
                    .foregroundColor(.green)
                    .font(.title2)
                
                Text("Weekly Cooking Goal")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(cookingStats.cookedThisWeek)/\(cookingStats.weeklyGoal)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress this week")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(Double(cookingStats.cookedThisWeek) / Double(cookingStats.weeklyGoal) * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
                
                ProgressView(value: Double(cookingStats.cookedThisWeek), total: Double(cookingStats.weeklyGoal))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                Text("Keep going! You're doing great this week! 🎉")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Statistics Section
    var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Cooking Statistics")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatisticCard(
                    icon: "book.fill",
                    title: "Total Recipes",
                    value: "\(cookingStats.totalRecipes)",
                    subtitle: "In your collection",
                    color: .blue,
                    animate: animateStats
                )
                
                StatisticCard(
                    icon: "heart.fill",
                    title: "Favorites",
                    value: "\(cookingStats.favoriteRecipes)",
                    subtitle: "Loved recipes",
                    color: .red,
                    animate: animateStats
                )
                
                StatisticCard(
                    icon: "clock.fill",
                    title: "Quick Meals",
                    value: "\(cookingStats.quickRecipes)",
                    subtitle: "Under 30 minutes",
                    color: .orange,
                    animate: animateStats
                )
                
                StatisticCard(
                    icon: "leaf.fill",
                    title: "Healthy",
                    value: "\(cookingStats.healthyRecipes)",
                    subtitle: "Nutritious options",
                    color: .green,
                    animate: animateStats
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Achievements Section
    var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                
                Text("Recent Achievements")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    showingAchievements = true
                }
                .font(.subheadline)
                .foregroundColor(.yellow)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    AchievementBadge(
                        icon: "star.fill",
                        title: "First Recipe",
                        description: "Generated your first AI recipe",
                        isUnlocked: cookingStats.totalRecipes > 0,
                        color: .blue
                    )
                    
                    AchievementBadge(
                        icon: "heart.fill",
                        title: "Recipe Lover",
                        description: "Saved 5 favorite recipes",
                        isUnlocked: cookingStats.favoriteRecipes >= 5,
                        color: .red
                    )
                    
                    AchievementBadge(
                        icon: "flame.fill",
                        title: "Speed Chef",
                        description: "Mastered quick cooking",
                        isUnlocked: cookingStats.quickRecipes >= 3,
                        color: .orange
                    )
                    
                    AchievementBadge(
                        icon: "leaf.fill",
                        title: "Health Guru",
                        description: "Focused on healthy eating",
                        isUnlocked: cookingStats.healthyRecipes >= 3,
                        color: .green
                    )
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Favorite Recipes Section
    var favoriteRecipesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                
                Text("Favorite Recipes")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if recipeManager.favoriteRecipes.count > 5 {
                    Text("View All (\(recipeManager.favoriteRecipes.count))")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(recipeManager.favoriteRecipes.prefix(5)) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            FavoriteRecipeCard(recipe: recipe)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Preferences Section
    var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(.purple)
                    .font(.title2)
                
                Text("Your Preferences")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Edit") {
                    showingEditProfile = true
                }
                .font(.subheadline)
                .foregroundColor(.purple)
            }
            
            VStack(spacing: 12) {
                PreferenceRow(
                    title: "Skill Level",
                    value: userProfile.skillLevel,
                    icon: "star.fill",
                    color: .orange
                )
                
                PreferenceRow(
                    title: "Dietary Restrictions",
                    value: userProfile.dietaryRestrictions.isEmpty ? "None" : userProfile.dietaryRestrictions.joined(separator: ", "),
                    icon: "leaf.fill",
                    color: .green
                )
                
                PreferenceRow(
                    title: "Allergies",
                    value: userProfile.allergies.isEmpty ? "None" : userProfile.allergies.joined(separator: ", "),
                    icon: "exclamationmark.triangle.fill",
                    color: .red
                )
                
                PreferenceRow(
                    title: "Favorite Cuisines",
                    value: userProfile.preferredCuisines.isEmpty ? "All" : userProfile.preferredCuisines.joined(separator: ", "),
                    icon: "globe",
                    color: .blue
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Supporting Models
struct CookingStats {
    let totalRecipes: Int
    let favoriteRecipes: Int
    let quickRecipes: Int
    let healthyRecipes: Int
    let weeklyGoal: Int
    let cookedThisWeek: Int
}

// MARK: - Supporting Views
struct SkillLevelBadge: View {
    let level: String
    
    var badgeColor: Color {
        switch level.lowercased() {
        case "beginner": return .green
        case "intermediate": return .orange
        case "advanced": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption)
            Text(level)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.2))
        .foregroundColor(badgeColor)
        .cornerRadius(12)
    }
}

struct ProfileActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct StatisticCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let animate: Bool
    
    @State private var animatedValue: Int = 0
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(animatedValue)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .onAppear {
                        if animate {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                animatedValue = Int(value) ?? 0
                            }
                        }
                    }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct AchievementBadge: View {
    let icon: String
    let title: String
    let description: String
    let isUnlocked: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color : Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isUnlocked ? .white : .gray)
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isUnlocked ? .primary : .secondary)
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(width: 80)
        .opacity(isUnlocked ? 1.0 : 0.6)
        .scaleEffect(isUnlocked ? 1.0 : 0.9)
    }
}

struct FavoriteRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: recipe.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.orange.opacity(0.3))
                    .overlay(
                        Text("🍽️")
                            .font(.title)
                    )
            }
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(12)
            
            VStack(spacing: 4) {
                Text(recipe.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("\(recipe.cookingTime)m")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: 100)
    }
}

struct PreferenceRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(value)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Binding var userProfile: UserProfile
    @Environment(\.dismiss) private var dismiss
    @State private var editingName: String = ""
    @State private var selectedSkillLevel = "Intermediate"
    
    let skillLevels = ["Beginner", "Intermediate", "Advanced", "Professional"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Your name", text: $editingName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Skill Level", selection: $selectedSkillLevel) {
                        ForEach(skillLevels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                }
                
                Section("Dietary Preferences") {
                    NavigationLink("Dietary Restrictions") {
                        // Dietary restrictions editor
                        Text("Coming soon...")
                    }
                    
                    NavigationLink("Allergies") {
                        // Allergies editor
                        Text("Coming soon...")
                    }
                    
                    NavigationLink("Preferred Cuisines") {
                        // Cuisines editor
                        Text("Coming soon...")
                    }
                }
                
                Section("App Settings") {
                    NavigationLink("Notification Preferences") {
                        // Notification settings
                        Text("Coming soon...")
                    }
                    
                    NavigationLink("Privacy Settings") {
                        // Privacy settings
                        Text("Coming soon...")
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                editingName = userProfile.name
                selectedSkillLevel = userProfile.skillLevel
            }
        }
    }
    
    private func saveProfile() {
        userProfile.name = editingName
        userProfile.skillLevel = selectedSkillLevel
    }
}

// MARK: - Achievements View
struct AchievementsView: View {
    let stats: CookingStats
    @Environment(\.dismiss) private var dismiss
    
    var allAchievements: [Achievement] {
        [
            Achievement(
                icon: "star.fill",
                title: "First Recipe",
                description: "Generated your first AI recipe",
                isUnlocked: stats.totalRecipes > 0,
                color: .blue
            ),
            Achievement(
                icon: "heart.fill",
                title: "Recipe Lover",
                description: "Saved 5 favorite recipes",
                isUnlocked: stats.favoriteRecipes >= 5,
                color: .red
            ),
            Achievement(
                icon: "flame.fill",
                title: "Speed Chef",
                description: "Mastered quick cooking (10+ quick recipes)",
                isUnlocked: stats.quickRecipes >= 10,
                color: .orange
            ),
            Achievement(
                icon: "leaf.fill",
                title: "Health Guru",
                description: "Focused on healthy eating (15+ healthy recipes)",
                isUnlocked: stats.healthyRecipes >= 15,
                color: .green
            ),
            Achievement(
                icon: "trophy.fill",
                title: "Master Chef",
                description: "Collected 50+ recipes",
                isUnlocked: stats.totalRecipes >= 50,
                color: .yellow
            ),
            Achievement(
                icon: "target",
                title: "Goal Achiever",
                description: "Completed weekly cooking goal",
                isUnlocked: stats.cookedThisWeek >= stats.weeklyGoal,
                color: .purple
            )
        ]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(allAchievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding()
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
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

struct Achievement: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let isUnlocked: Bool
    let color: Color
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.color : Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.title)
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
            }
            
            VStack(spacing: 8) {
                Text(achievement.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            if achievement.isUnlocked {
                Text("UNLOCKED")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(achievement.color)
                    .cornerRadius(8)
            } else {
                Text("LOCKED")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
        .scaleEffect(achievement.isUnlocked ? 1.0 : 0.95)
    }
}

#Preview {
    ProfileView()
        .environmentObject(RecipeManager())
}
