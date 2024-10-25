//
//  NotificationSettingsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/16/24.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var breakfastNotification: Bool = UserDefaults.standard.bool(forKey: "breakfastNotification")
    @State private var breakfastTime: Date = (UserDefaults.standard.object(forKey: "breakfastTime") as? Date ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())) ?? Date()
    
    @State private var lunchNotification: Bool = UserDefaults.standard.bool(forKey: "lunchNotification")
    @State private var lunchTime: Date = (UserDefaults.standard.object(forKey: "lunchTime") as? Date ?? Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())) ?? Date()
    
    @State private var dinnerNotification: Bool = UserDefaults.standard.bool(forKey: "dinnerNotification")
    @State private var dinnerTime: Date = (UserDefaults.standard.object(forKey: "dinnerTime") as? Date ?? Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())) ?? Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: $breakfastNotification) {
                        Text("조식 알림")
                    }
                    DatePicker("시간", selection: $breakfastTime, displayedComponents: .hourAndMinute)
                }
                .onChange(of: breakfastNotification) { oldValue, newValue in
                    UserDefaults.standard.set(newValue, forKey: "breakfastNotification")
                    handleNotificationChange(meal: "조식", notificationEnabled: newValue, time: breakfastTime)
                }
                .onChange(of: breakfastTime) { oldValue, newValue in
                    UserDefaults.standard.set(newValue, forKey: "breakfastTime")
                    handleNotificationChange(meal: "조식", notificationEnabled: breakfastNotification, time: newValue)
                }
                
                Section {
                    Toggle(isOn: $lunchNotification) {
                        Text("중식 알림")
                    }
                    DatePicker("시간", selection: $lunchTime, displayedComponents: .hourAndMinute)
                }
                .onChange(of: lunchNotification) { oldValue, newValue in
                    UserDefaults.standard.set(newValue, forKey: "lunchNotification")
                    handleNotificationChange(meal: "중식", notificationEnabled: newValue, time: lunchTime)
                }
                .onChange(of: lunchTime) { oldValue, newValue in
                    UserDefaults.standard.set(newValue, forKey: "lunchTime")
                    handleNotificationChange(meal: "중식", notificationEnabled: lunchNotification, time: newValue)
                }
                
                Section {
                    Toggle(isOn: $dinnerNotification) {
                        Text("석식 알림")
                    }
                    DatePicker("시간", selection: $dinnerTime, displayedComponents: .hourAndMinute)
                }
                .onChange(of: dinnerNotification) { oldValue, newValue in
                    UserDefaults.standard.set(newValue, forKey: "dinnerNotification")
                    handleNotificationChange(meal: "석식", notificationEnabled: newValue, time: dinnerTime)
                }
                .onChange(of: dinnerTime) { oldValue, newValue in
                    UserDefaults.standard.set(newValue, forKey: "dinnerTime")
                    handleNotificationChange(meal: "석식", notificationEnabled: dinnerNotification, time: newValue)
                }
            }
            .navigationTitle("알림")
            .onAppear {
                breakfastNotification = UserDefaults.standard.bool(forKey: "breakfastNotification")
                breakfastTime = (UserDefaults.standard.object(forKey: "breakfastTime") as? Date) ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!

                lunchNotification = UserDefaults.standard.bool(forKey: "lunchNotification")
                lunchTime = (UserDefaults.standard.object(forKey: "lunchTime") as? Date) ?? Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!

                dinnerNotification = UserDefaults.standard.bool(forKey: "dinnerNotification")
                dinnerTime = (UserDefaults.standard.object(forKey: "dinnerTime") as? Date) ?? Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
            }
        }
    }
    
    private func handleNotificationChange(meal: String, notificationEnabled: Bool, time: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        }
        
        if notificationEnabled {
            scheduleNotification(meal: meal, time: time)
        } else {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [meal])
        }
    }
    
    private func scheduleNotification(meal: String, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "데일리 동산"
        content.body = "오늘의 \(meal) 메뉴를 확인해 보세요. 🍽️"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        let calendar = Calendar.current
        dateComponents.hour = calendar.component(.hour, from: time)
        dateComponents.minute = calendar.component(.minute, from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: meal, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
    }
}

#Preview {
    NotificationSettingsView()
}
