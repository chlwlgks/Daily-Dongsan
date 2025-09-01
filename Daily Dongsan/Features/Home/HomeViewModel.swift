//
//  HomeViewModel.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/11/25.
//

import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var isMealsLoading: Bool = false
    @Published var meals: [Meal] = []
    @Published var announcement: String?
    
    func currentDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일 EEEE"
        return dateFormatter.string(from: Date())
    }
    
    @MainActor
    func fetchMeals() async {
        withAnimation {
            isMealsLoading = true
        }
        let fetched = await FetchMeals().fetchMeals(for: Date())
        meals = fetched
        withAnimation {
            isMealsLoading = false
        }
    }
    
    @MainActor
    func fetchAnnouncement() async {
        let db = Firestore.firestore()
        let fetched = try? await db.collection("announcement").document("content").getDocument().data()?["text"] as! String?
        withAnimation {
            announcement = fetched
        }
    }
}
