//
//  MealPlanViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/12/25.
//

import SwiftUI

class MealPlanViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var selectedDate = Date()
    @Published var meals: [Meal] = []
    
    init() {
        Task {
            await fetchMeals()
        }
    }
    
    func selectedDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MMM d일 EEEE"
        return dateFormatter.string(from: selectedDate)
    }
    
    @MainActor
    func fetchMeals() async {
        withAnimation {
            isLoading = true
        }
        let fetched = await FetchMeals().fetchMeals(for: selectedDate)
        meals = fetched
        withAnimation {
            isLoading = false
        }
    }
}
