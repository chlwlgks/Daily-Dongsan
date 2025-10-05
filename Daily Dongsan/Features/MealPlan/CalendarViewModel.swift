//
//  CalendarViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/12/25.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    @Published var selectedDate = Date()
    
    @Published var meals: [Meal] = []
    
    func selectedDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MMM d일 EEEE"
        return dateFormatter.string(from: selectedDate)
    }
    
    func fetchMeals() async {
        await MainActor.run {
            withAnimation {
                isLoading = true
            }
        }
        let fetched = await FetchMeals().fetchMeals(for: selectedDate)
        await MainActor.run {
            withAnimation {
                meals = fetched
                isLoading = false
            }
        }
    }
    
    private let selectedAllergies = Set(UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? [])
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
