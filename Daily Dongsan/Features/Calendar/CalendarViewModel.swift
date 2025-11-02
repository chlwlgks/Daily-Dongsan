//
//  CalendarViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/12/25.
//

import SwiftUI

@Observable
class CalendarViewModel {
    var isLoading: Bool = false
    
    var selectedDate = Date()
    var schedule: String?
    var meals: [Meal] = []
    
    var selectedDateAsString: String {
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        let selectedYear = calendar.component(.year, from: selectedDate)
        let currentYear = calendar.component(.year, from: Date())
        
        if selectedYear == currentYear {
            dateFormatter.dateFormat = "M월 d일 EEEE"
        } else {
            dateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        }
        
        return dateFormatter.string(from: selectedDate)
    }
    
    func fetchScheduleAndMeals() async {
        await MainActor.run {
            withAnimation {
                isLoading = true
            }
        }
        
        async let scheduleTask = FetchSchedules().fetchSchedules(for: selectedDate)
        async let mealsTask = FetchMeals().fetchMeals(for: selectedDate)
        
        let scheduleResult = await scheduleTask
        let mealsResult = await mealsTask
        
        await MainActor.run {
            withAnimation {
                schedule = scheduleResult
                meals = mealsResult
                isLoading = false
            }
        }
    }
    
    var selectedAllergies: Set<String> {
        let ids = UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? []
        return Set(ids)
    }
    func attributedMenuList(for menus: [Menu]) -> AttributedString {
        var result = AttributedString()
        
        for (i, menu) in menus.enumerated() {
            var substr = AttributedString(menu.name)
            
            if let list = menu.allergies, !list.isDisjoint(with: selectedAllergies) {
                substr.foregroundColor = .red
            }
            
            result.append(substr)
            
            if i < menus.count - 1 {
                result.append(AttributedString(", "))
            }
        }
        
        return result
    }
}

