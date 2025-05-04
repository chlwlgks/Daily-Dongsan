//
//  MealPlanViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/12/25.
//

import Foundation

class MealPlanViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var meals: [Meal] = []
    
    init() {
        Task { @MainActor in
            meals = await FetchMeals().fetchMeals(for: selectedDate)
        }
    }
    
    func selectedDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MMM d일 EEEE"
        return dateFormatter.string(from: selectedDate)
    }
    
    func fetchMeals() async {
        Task { @MainActor in
            meals = await FetchMeals().fetchMeals(for: selectedDate)
        }
    }
}
