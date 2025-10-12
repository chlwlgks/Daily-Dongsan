//
//  NotificationManager.swift
//  Daily Dongsan
//
//  Created by 최지한 on 7/9/25.
//

import SwiftUI

private enum NotificationMeal: String {
    case breakfast, lunch, dinner
}

@Observable
class NotificationSettingsViewModel {
    var notificationAuthorizationStatus: UNAuthorizationStatus = .authorized
    var breakfastNotificationEnabled: Bool {
        get {
            access(keyPath: \.breakfastNotificationEnabled)
            return UserDefaults.standard.bool(forKey: "breakfastNotificationEnabled")
        }
        set {
            withMutation(keyPath: \.breakfastNotificationEnabled) {
                persistAndSchedule(meal: .breakfast, enabled: newValue, time: breakfastNotificationTime)
            }
        }
    }
    var breakfastNotificationTime: Date {
        get {
            access(keyPath: \.breakfastNotificationTime)
            return (UserDefaults.standard.object(forKey: "breakfastNotificationTime") as? Date) ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        }
        set {
            withMutation(keyPath: \.breakfastNotificationTime) {
                persistAndSchedule(meal: .breakfast, enabled: breakfastNotificationEnabled, time: newValue)
            }
        }
    }
    var lunchNotificationEnabled: Bool {
        get {
            access(keyPath: \.lunchNotificationEnabled)
            return UserDefaults.standard.bool(forKey: "lunchNotificationEnabled")
        }
        set {
            withMutation(keyPath: \.lunchNotificationEnabled) {
                persistAndSchedule(meal: .lunch, enabled: newValue, time: lunchNotificationTime)
            }
        }
    }
    var lunchNotificationTime: Date {
        get {
            access(keyPath: \.lunchNotificationTime)
            return (UserDefaults.standard.object(forKey: "lunchNotificationTime") as? Date) ?? Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        }
        set {
            withMutation(keyPath: \.lunchNotificationTime) {
                persistAndSchedule(meal: .lunch, enabled: lunchNotificationEnabled, time: newValue)
            }
        }
    }
    var dinnerNotificationEnabled: Bool {
        get {
            access(keyPath: \.dinnerNotificationEnabled)
            return UserDefaults.standard.bool(forKey: "dinnerNotificationEnabled")
        }
        set {
            withMutation(keyPath: \.dinnerNotificationEnabled) {
                persistAndSchedule(meal: .dinner, enabled: newValue, time: dinnerNotificationTime)
            }
        }
    }
    var dinnerNotificationTime: Date {
        get {
            access(keyPath: \.dinnerNotificationTime)
            return (UserDefaults.standard.object(forKey: "dinnerNotificationTime") as? Date) ?? Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
        }
        set {
            withMutation(keyPath: \.dinnerNotificationTime) {
                persistAndSchedule(meal: .dinner, enabled: dinnerNotificationEnabled, time: newValue)
            }
        }
    }
    
    init() {
        refreshAuthorizationStatus()
    }
    
    private func refreshAuthorizationStatus() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                withAnimation {
                    self.notificationAuthorizationStatus = settings.authorizationStatus
                }
            }
        }
    }
    
    func requestAuthorizationIfNeeded() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else {
                self.refreshAuthorizationStatus()
                return
            }
            
            center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }
    
    private func persistAndSchedule(meal: NotificationMeal, enabled: Bool, time: Date) {
        let keyEnabled = "\(meal.rawValue)NotificationEnabled"
        UserDefaults.standard.set(enabled, forKey: keyEnabled)
        
        let keyTime = "\(meal.rawValue)NotificationTime"
        UserDefaults.standard.set(time, forKey: keyTime)
        
        if enabled {
            let body: String
            switch meal {
            case .breakfast:
                body = "조식 메뉴를 확인해 보세요. 🍴"
            case .lunch:
                body = "중식 메뉴를 확인해 보세요. 🍛"
            case .dinner:
                body = "석식 메뉴를 확인해 보세요. 😋"
            }
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: time)
            let minute = calendar.component(.minute, from: time)
            
            scheduleNotifications(body: body, hour: hour, minute: minute, idPrefix: meal.rawValue)
        } else {
            cancelNotifications(idPrefix: meal.rawValue)
        }
    }
    
    private func scheduleNotifications(body: String, hour: Int, minute: Int, idPrefix: String) {
        let content = UNMutableNotificationContent()
        content.title = "데일리 동산"
        content.body = body
        content.sound = .default
        
        for weekday in 2...6 {
            var dateComponents = DateComponents()
            dateComponents.weekday = weekday
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.calendar = Calendar(identifier: .gregorian)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let identifier = "\(idPrefix)_\(weekday)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func cancelNotifications(idPrefix: String) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let identifiers = requests
                .map { $0.identifier }
                .filter { $0.hasPrefix(idPrefix) }
            center.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
}
