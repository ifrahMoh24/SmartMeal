//
//  NotificationService.swift
//  SmartMeal1
//
//  Simple notification implementation for demo
//

import Foundation
import UserNotifications

class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    private init() {}
    
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }
    
    func scheduleRecipeReminder() {
        let content = UNMutableNotificationContent()
        content.title = "🍽️ SmartMeal Reminder"
        content.body = "Time to cook something delicious! Check out your saved recipes."
        content.sound = .default
        content.badge = 1
        
        // Schedule for 5 seconds from now (for demo)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "recipe-reminder-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Recipe reminder scheduled successfully")
            }
        }
    }
    
    func scheduleCookingTimer(minutes: Int, recipeName: String) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Cooking Timer"
        content.body = "Your \(recipeName) should be ready! Time to check your food."
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(minutes * 60), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "cooking-timer-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling cooking timer: \(error)")
            } else {
                print("Cooking timer scheduled for \(minutes) minutes")
            }
        }
    }
    
    func scheduleMealPlanningReminder() {
        let content = UNMutableNotificationContent()
        content.title = "📅 Meal Planning Time"
        content.body = "Plan your meals for the week! Open SmartMeal to get started."
        content.sound = .default
        content.badge = 1
        
        // Schedule for daily at 6 PM
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "meal-planning-reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling meal planning reminder: \(error)")
            } else {
                print("Daily meal planning reminder scheduled")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("All notifications cancelled")
    }
    
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification with identifier \(identifier) cancelled")
    }
}
