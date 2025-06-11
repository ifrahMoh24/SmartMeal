//
//  SettingsView.swift
//  SmartMeal1
//
//  Updated version without Maps integration
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("mealReminders") private var mealReminders = true
    @AppStorage("selectedCuisine") private var selectedCuisine = "All"
    @AppStorage("maxCookingTime") private var maxCookingTime = 30.0
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    let cuisineTypes = ["All", "Italian", "Asian", "Mediterranean", "Mexican", "Indian", "American"]
    
    var body: some View {
        NavigationView {
            Form {
                // App Preferences Section
                Section {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.orange)
                            .frame(width: 30)
                        
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                            .onChange(of: notificationsEnabled) { value in
                                if value {
                                    requestNotificationPermission()
                                }
                            }
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        Toggle("Meal Reminders", isOn: $mealReminders)
                            .disabled(!notificationsEnabled)
                    }
                    
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.purple)
                            .frame(width: 30)
                        
                        Toggle("Dark Mode", isOn: $isDarkMode)
                    }
                } header: {
                    Text("App Preferences")
                }
                
                // Cooking Preferences Section
                Section {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.green)
                            .frame(width: 30)
                        
                        Picker("Preferred Cuisine", selection: $selectedCuisine) {
                            ForEach(cuisineTypes, id: \.self) { cuisine in
                                Text(cuisine).tag(cuisine)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.orange)
                                .frame(width: 30)
                            
                            Text("Max Cooking Time: \(Int(maxCookingTime)) minutes")
                        }
                        
                        Slider(value: $maxCookingTime, in: 10...120, step: 5) {
                            Text("Cooking Time")
                        }
                        .accentColor(.orange)
                    }
                } header: {
                    Text("Cooking Preferences")
                }
                
                // Account Section
                Section {
                    NavigationLink("Dietary Restrictions") {
                        DietaryRestrictionsView()
                    }
                    
                    NavigationLink("Allergies & Intolerances") {
                        AllergiesView()
                    }
                    
                    NavigationLink("About SmartMeal") {
                        AboutView()
                    }
                } header: {
                    Text("Account & Info")
                }
                
                // Data Management Section
                Section {
                    Button {
                        clearRecipeHistory()
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .frame(width: 30)
                            Text("Clear Recipe History")
                            Spacer()
                        }
                    }
                    .foregroundColor(.red)
                    
                    Button {
                        exportFavorites()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Text("Export Favorites")
                            Spacer()
                        }
                    }
                    .foregroundColor(.blue)
                } header: {
                    Text("Data Management")
                }
                
                // App Info Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("2025.06.11")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("App Information")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.notificationsEnabled = granted
                if granted {
                    scheduleTestNotification()
                }
            }
        }
    }
    
    private func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "SmartMeal"
        content.body = "Time to cook something delicious! 🍽️"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func clearRecipeHistory() {
        // Clear recipe history logic
        print("Recipe history cleared")
    }
    
    private func exportFavorites() {
        // Export favorites logic
        print("Favorites exported")
    }
}

// MARK: - Supporting Views

struct DietaryRestrictionsView: View {
    @AppStorage("dietaryRestrictions") private var savedRestrictions = ""
    @State private var selectedRestrictions: Set<String> = []
    
    let restrictions = [
        "Vegetarian", "Vegan", "Gluten-Free", "Dairy-Free",
        "Keto", "Paleo", "Low-Carb", "Low-Fat", "Nut-Free"
    ]
    
    var body: some View {
        List {
            ForEach(restrictions, id: \.self) { restriction in
                HStack {
                    Text(restriction)
                    Spacer()
                    if selectedRestrictions.contains(restriction) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedRestrictions.contains(restriction) {
                        selectedRestrictions.remove(restriction)
                    } else {
                        selectedRestrictions.insert(restriction)
                    }
                    saveRestrictions()
                }
            }
        }
        .navigationTitle("Dietary Restrictions")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadRestrictions()
        }
    }
    
    private func loadRestrictions() {
        if !savedRestrictions.isEmpty {
            selectedRestrictions = Set(savedRestrictions.components(separatedBy: ","))
        }
    }
    
    private func saveRestrictions() {
        savedRestrictions = Array(selectedRestrictions).joined(separator: ",")
    }
}

struct AllergiesView: View {
    @AppStorage("allergies") private var savedAllergies = ""
    @State private var selectedAllergies: Set<String> = []
    
    let allergies = [
        "Nuts", "Peanuts", "Shellfish", "Fish", "Eggs",
        "Dairy", "Soy", "Wheat", "Sesame", "Sulfites"
    ]
    
    var body: some View {
        List {
            ForEach(allergies, id: \.self) { allergy in
                HStack {
                    Text(allergy)
                    Spacer()
                    if selectedAllergies.contains(allergy) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedAllergies.contains(allergy) {
                        selectedAllergies.remove(allergy)
                    } else {
                        selectedAllergies.insert(allergy)
                    }
                    saveAllergies()
                }
            }
        }
        .navigationTitle("Allergies & Intolerances")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadAllergies()
        }
    }
    
    private func loadAllergies() {
        if !savedAllergies.isEmpty {
            selectedAllergies = Set(savedAllergies.components(separatedBy: ","))
        }
    }
    
    private func saveAllergies() {
        savedAllergies = Array(selectedAllergies).joined(separator: ",")
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 16) {
                    Circle()
                        .fill(Color.orange.gradient)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text("🍽️")
                                .font(.system(size: 50))
                        )
                    
                    Text("SmartMeal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("AI-Powered Recipe Assistant")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("About")
                        .font(.headline)
                    
                    Text("SmartMeal is an innovative mobile application that uses artificial intelligence to transform your available ingredients into personalized recipe suggestions. Built with cutting-edge iOS technologies including Core ML for ingredient recognition and SwiftUI for modern user interfaces.")
                        .font(.body)
                        .lineSpacing(4)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Features")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "camera.viewfinder", title: "AI Ingredient Detection", description: "Scan ingredients with your camera using Core ML")
                        FeatureRow(icon: "brain", title: "Smart Recipe Generation", description: "Get personalized recipes based on your ingredients")
                        FeatureRow(icon: "heart.fill", title: "Favorites & Profile", description: "Save your favorite recipes and manage preferences")
                        FeatureRow(icon: "bell.fill", title: "Smart Notifications", description: "Get meal reminders and cooking tips")
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Technology")
                        .font(.headline)
                    
                    Text("Built with SwiftUI, Core ML, UserNotifications, and modern iOS development practices. Implements MVVM architecture for clean, maintainable code.")
                        .font(.body)
                        .lineSpacing(4)
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
}
