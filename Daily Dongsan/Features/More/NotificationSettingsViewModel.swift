//
//  NotificationManager.swift
//  Daily Dongsan
//
//  Created by 최지한 on 7/9/25.
//

import SwiftUI

enum NotificationMeal: String {
    case breakfast
    case lunch
    case dinner
}

class NotificationSettingsViewModel: ObservableObject {
    @Environment(\.openURL) private var openURL
    
    @Published var notificationAuthorizationStatus: UNAuthorizationStatus = .authorized
    @Published var breakfastNotificationEnabled: Bool {
        didSet { persistAndSchedule(meal: .breakfast, enabled: breakfastNotificationEnabled, time: breakfastNotificationTime) }
    }
    @Published var breakfastNotificationTime: Date {
        didSet { persistAndSchedule(meal: .breakfast, enabled: breakfastNotificationEnabled, time: breakfastNotificationTime) }
    }
    @Published var lunchNotificationEnabled: Bool {
        didSet { persistAndSchedule(meal: .lunch, enabled: lunchNotificationEnabled, time: lunchNotificationTime) }
    }
    @Published var lunchNotificationTime: Date {
        didSet { persistAndSchedule(meal: .lunch, enabled: lunchNotificationEnabled, time: lunchNotificationTime) }
    }
    @Published var dinnerNotificationEnabled: Bool {
        didSet { persistAndSchedule(meal: .dinner, enabled: dinnerNotificationEnabled, time: dinnerNotificationTime) }
    }
    @Published var dinnerNotificationTime: Date {
        didSet { persistAndSchedule(meal: .dinner, enabled: dinnerNotificationEnabled, time: dinnerNotificationTime) }
    }
    
    init() {
        breakfastNotificationEnabled = UserDefaults.standard.bool(forKey: "breakfastNotificationEnabled")
        breakfastNotificationTime = (UserDefaults.standard.object(forKey: "breakfastNotificationTime") as? Date) ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        lunchNotificationEnabled = UserDefaults.standard.bool(forKey: "lunchNotificationEnabled")
        lunchNotificationTime = (UserDefaults.standard.object(forKey: "lunchNotificationTime") as? Date) ?? Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        dinnerNotificationEnabled = UserDefaults.standard.bool(forKey: "dinnerNotificationEnabled")
        dinnerNotificationTime = (UserDefaults.standard.object(forKey: "dinnerNotificationTime") as? Date) ?? Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
        fetchAuthorizationStatus()
    }
    
    func fetchAuthorizationStatus() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                withAnimation {
                    self.notificationAuthorizationStatus = settings.authorizationStatus
                }
            }
            
            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
            }
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
                //                body = "조식 메뉴를 확인해 보세요. 🍽️"
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
        let cetner = UNUserNotificationCenter.current()
        cetner.getPendingNotificationRequests { requests in
            let identifiers = requests
                .map { $0.identifier }
                .filter { $0.hasPrefix(idPrefix) }
            cetner.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
}
