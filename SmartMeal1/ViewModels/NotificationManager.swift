//
//  NotificationManager.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//

import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var isAuthorized = false
    
    init() {
        checkAuthorizationStatus()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
            }
            
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Cooking Timer Notifications
    
    func scheduleCookingTimer(for recipe: Recipe, delay: TimeInterval = 0) {
        guard isAuthorized else {
            requestAuthorization()
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "⏰ Cooking Timer"
        content.body = "Your \(recipe.title) should be ready!"
        content.sound = .default
        content.badge = 1
        
        // Calculate total cooking time in seconds
        let cookingTimeInSeconds = TimeInterval(recipe.cookingTime * 60) + delay
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: cookingTimeInSeconds,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "cookingTimer-\(recipe.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Cooking timer scheduled for \(recipe.title)")
            }
        }
    }
    
    func cancelCookingTimer(for recipe: Recipe) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["cookingTimer-\(recipe.id)"]
        )
    }
    
    // MARK: - Meal Planning Reminders
    
    func scheduleMealReminder(recipeName: String, date: Date) {
        guard isAuthorized else {
            requestAuthorization()
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "🍽️ Meal Reminder"
        content.body = "Time to prepare: \(recipeName)"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "mealReminder-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling meal reminder: \(error)")
            }
        }
    }
    
    // MARK: - Shopping List Reminder
    
    func scheduleShoppingReminder(ingredients: [String]) {
        guard isAuthorized else {
            requestAuthorization()
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "🛒 Shopping Reminder"
        content.body = "Don't forget to buy: \(ingredients.prefix(3).joined(separator: ", "))"
        if ingredients.count > 3 {
            content.body += " and \(ingredients.count - 3) more items"
        }
        content.sound = .default
        
        // Schedule for tomorrow at 10 AM
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "shoppingReminder-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}