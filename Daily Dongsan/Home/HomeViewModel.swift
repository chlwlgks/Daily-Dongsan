//
//  HomeViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/11/25.
//

import Foundation
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    
    init() {
        Task { @MainActor in
            meals = await FetchMeals().fetchMeals(for: Date())
        }
    }
    
    func currentDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MMM d일 EEEE"
        return dateFormatter.string(from: Date())
    }
    
    func fetchMeals() async {
        Task { @MainActor in
            meals = await FetchMeals().fetchMeals(for: Date())
        }
    }
}
