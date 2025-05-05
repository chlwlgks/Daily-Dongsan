//
//  HomeView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.colorScheme) private var scheme
    
    @ObservedObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text(viewModel.currentDateAsString())
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(.gray)
                    Text("안산동산고등학교")
                        .font(.system(.largeTitle, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, horizontalSizeClass == .compact ? 16 : 0)
                .padding(.top, horizontalSizeClass == .compact ? 16 : 0)
                
                if let announcement = viewModel.announcement, !announcement.isEmpty {
                    Label {
                        Text(announcement)
                    } icon: {
                        Image(systemName: "megaphone.fill")
                            .foregroundStyle(.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.secondary.opacity(scheme == .light ? 0.1 : 0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                }
                
                if horizontalSizeClass == .regular {
                    if viewModel.isLoading {
                        RegularHomeView(meals: Meal.sampleMeals)
                            .skeleton(isRedacted: true)
                    } else {
                        RegularHomeView(meals: viewModel.meals)
                    }
                } else {
                    if viewModel.isLoading {
                        RegularMealListView(meals: Meal.sampleMeals)
                            .skeleton(isRedacted: true)
                    } else {
                        RegularMealListView(meals: viewModel.meals)
                    }
                }
                
                Spacer()
            }
            .onAppear {
                Task {
                    await viewModel.fetchMeals()
                    await viewModel.fetchAnnouncement()
                }
            }
        }
    }
    
    private struct RegularHomeView: View {
        private let selectedAllergies = Set(UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? [])
        let meals: [Meal]
        
        var body: some View {
            HStack(alignment: .top) {
                ForEach(meals, id: \.mealCode) { meal in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(meal.mealType)
                            if let calorie = meal.calorieInfo {
                                Spacer()
                                Text(calorie)
                            }
                        }
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 1)
                        
                        if let menus = meal.menus, !menus.isEmpty {
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
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if meal.mealCode != "3" {
                        Divider()
                            .padding(.horizontal, 5)
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}
