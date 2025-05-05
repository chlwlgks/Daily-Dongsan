//
//  HomeViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/11/25.
//

import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var meals: [Meal] = []
    
    init() {
        Task {
            await fetchMeals()
        }
    }
    
    func currentDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MMM d일 EEEE"
        return dateFormatter.string(from: Date())
    }
    
    @MainActor
    func fetchMeals() async {
        withAnimation(.smooth) {
            isLoading = true
        }
        let fetched = await FetchMeals().fetchMeals(for: Date())
        meals = fetched
        withAnimation(.smooth) {
            isLoading = false
        }
    }
}
