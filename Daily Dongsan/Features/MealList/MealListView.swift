//
//  MealListView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 4/12/25.
//

import SwiftUI

struct RegularMealListView: View {
    @ObservedObject private var viewModel = MealListViewModel()
    
    private let selectedAllergies = Set(UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? [])
    
    let meals: [Meal]
    
    var body: some View {
        List(meals, id: \.mealCode) { meal in
            Section {
                if let menus = meal.menus {
                    VStack(alignment: .leading) {
                        ForEach(menus, id: \.self) { menu in
                            if let list = menu.allergies, !Set(list).isDisjoint(with: selectedAllergies) {
                                Text(menu.name)
                                    .foregroundStyle(.red)
                            } else {
                                Text(menu.name)
                            }
                        }
                    }
                } else {
                    Text("급식 정보가 없습니다.")
                }
            } header: {
                HStack {
                    Text(meal.mealType)
                    if let calorie = meal.calorieInfo {
                        Spacer()
                        Text(calorie)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct CompactMealListView: View {
    @ObservedObject private var viewModel = MealListViewModel()
    
    let meals: [Meal]
    
    var body: some View {
        List(meals, id: \.mealCode) { meal in
            Section {
                Text(viewModel.attributedMenuList(for: meal.menus))
            } header: {
                HStack {
                    Text(meal.mealType)
                    if let calorie = meal.calorieInfo {
                        Spacer()
                        Text(calorie)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview("Regular Meal List View") {
    RegularMealListView(meals: Meal.sampleMeals)
}

#Preview("Compact Meal List View") {
    CompactMealListView(meals: Meal.sampleMeals)
}
