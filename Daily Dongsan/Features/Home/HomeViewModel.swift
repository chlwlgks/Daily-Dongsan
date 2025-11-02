//
//  HomeViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/11/25.
//

import SwiftUI
import FirebaseFirestore

@Observable
class HomeViewModel {
    var showNextDayAfter7PM: Bool {
        get {
            access(keyPath: \.showNextDayAfter7PM)
            return UserDefaults.standard.object(forKey: "showNextDayAfter7PM") as? Bool ?? true
        }
    }
    var skipWeekends: Bool {
        get {
            access(keyPath: \.skipWeekends)
            return UserDefaults.standard.object(forKey: "skipWeekends") as? Bool ?? true
        }
    }
    
    var isMealsLoading: Bool = false
    
    var announcement: String?
    var schedule: String?
    var meals: [Meal] = []
    
    private enum DateChangeReason {
        case none, nextDayAfter7PM, skipWeekends
    }
    
    private func computeTargetDate() -> (date: Date, reason: DateChangeReason) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        var date = Date()
        var reason: DateChangeReason = .none
        
        if showNextDayAfter7PM {
            let hour = calendar.component(.hour, from: date)
            if hour >= 19 {
                date = calendar.date(byAdding: .day, value: 1, to: date)!
                reason = .nextDayAfter7PM
            }
        }
        
        if skipWeekends {
            while calendar.isDateInWeekend(date) {
                date = calendar.date(byAdding: .day, value: 1, to: date)!
                reason = .skipWeekends
            }
        }
        
        return (date, reason)
    }
    
    func currentDateAsString() -> String {
        let (date, reason) = computeTargetDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        let formatted = dateFormatter.string(from: date)
        
        switch reason {
        case .none:
            return formatted
        case .nextDayAfter7PM:
            return "내일: \(formatted)"
        case .skipWeekends:
            return "다음 월요일: \(formatted)"
        }
    }
    
    func fetchScheduleAndMeals() async {
        await MainActor.run {
            withAnimation {
                isMealsLoading = true
            }
        }

        let target = computeTargetDate().date

        async let scheduleTask = FetchSchedules().fetchSchedules(for: target)
        async let mealsTask = FetchMeals().fetchMeals(for: target)

        let scheduleResult = await scheduleTask
        let mealsResult = await mealsTask

        await MainActor.run {
            withAnimation {
                schedule = scheduleResult
                meals = mealsResult
                isMealsLoading = false
            }
        }
    }
    
    func fetchAnnouncement() async {
        let db = Firestore.firestore()
        do {
            let fetched = try await db.collection("announcement").document("content").getDocument().data()?["text"] as? String
            await MainActor.run {
                withAnimation {
                    announcement = fetched
                }
            }
        } catch {
            print("공지 로드 오류: \(error.localizedDescription)")
        }
    }
}

