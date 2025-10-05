//
//  Meal.swift
//  geubchelin
//
//  Created by 최지한 on 1/25/25.
//

import Foundation

enum MealKind: String, Codable, Hashable {
    case breakfast = "1"
    case lunch = "2"
    case dinner = "3"
    
    var displayName: String {
        switch self {
        case .breakfast: return "조식"
        case .lunch: return "중식"
        case .dinner: return "석식"
        }
    }
}

struct Meal: Hashable {
    let mealKind: MealKind
    var menus: [Menu]?
    var calorieInfo: String?
}

struct Menu: Hashable {
    let name: String
    let allergies: Set<String>?
}

extension Meal {
    static let sampleMeals: [Meal] = [
        Meal(
            mealKind: .breakfast,
            menus: [
                Menu(name: "크로와상샌드위치", allergies: ["1", "2", "5", "6", "10", "12"]),
                Menu(name: "햄야채볶음밥", allergies: ["2", "5", "6", "10", "15", "16", "18"]),
                Menu(name: "와플감자*케찹", allergies: ["5", "6", "12"]),
                Menu(name: "포기김치", allergies: ["9"]),
                Menu(name: "씨리얼&우유", allergies: ["2", "5"]),
                Menu(name: "샤인머스켓주스", allergies: nil)
            ]
        ),
        Meal(
            mealKind: .lunch,
            menus: [
                Menu(name: "랍스터버터구이", allergies: ["2", "5", "6", "9", "13"]),
                Menu(name: "스파게티", allergies: ["1", "2", "5", "6", "10", "12", "13", "15", "16"]),
                Menu(name: "마늘빵", allergies: ["1", "2", "6"]),
                Menu(name: "양송이스프", allergies: ["2", "5", "6", "13", "16"]),
                Menu(name: "망고&바나나 샐러드", allergies: ["13"]),
                Menu(name: "동산오이무피클", allergies: ["13"]),
                Menu(name: "새콤달콤자두", allergies: nil),
                Menu(name: "후리카케밥(추)", allergies: ["1", "2", "5", "6", "9", "13", "16", "18"]),
                Menu(name: "깍두기(추가)", allergies: ["9"])
            ],
            calorieInfo: "1034.7 Kcal"
        ),
        Meal(
            mealKind: .dinner,
            menus: [
                Menu(name: "잡곡밥", allergies: nil),
                Menu(name: "부대찌개&라면사리", allergies: ["5", "6", "9", "10", "15"]),
                Menu(name: "맛밤송송함박스테이크", allergies: ["1", "5", "6", "10", "16"]),
                Menu(name: "크랜베리멸치볶음", allergies: ["5", "6"]),
                Menu(name: "유부맛살냉채", allergies: ["1", "5", "6", "8", "12"]),
                Menu(name: "총각김치", allergies: ["5", "9"]),
                Menu(name: "방울토마토", allergies: ["12"])
            ]
        )
    ]
}
