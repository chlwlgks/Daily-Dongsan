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
                
                if viewModel.isAnnouncementLoading {
                    Label {
                        Text("하님을 경외하고 이웃을 사랑하자")
                    } icon: {
                        Image(systemName: "megaphone.fill")
                            .foregroundStyle(.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.secondary.opacity(scheme == .light ? 0.1 : 0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .skeleton(isRedacted: true)
                    .padding(.horizontal)
                    .padding(horizontalSizeClass == .regular ? .bottom : .init())
                } else if let announcement = viewModel.announcement, !announcement.isEmpty {
                    Label {
                        Text(announcement)
                            .textSelection(.enabled)
                    } icon: {
                        Image(systemName: "megaphone.fill")
                            .foregroundStyle(.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.secondary.opacity(scheme == .light ? 0.1 : 0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .padding(horizontalSizeClass == .regular ? .bottom : .init())
                }
                
                if horizontalSizeClass == .regular {
                    if viewModel.isMealsLoading {
                        RegularHomeView(meals: Meal.sampleMeals)
                            .skeleton(isRedacted: true)
                    } else {
                        RegularHomeView(meals: viewModel.meals)
                    }
                } else {
                    if viewModel.isMealsLoading {
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
                    async let mealsTask: () = viewModel.fetchMeals()
                    async let announcementTask: () = viewModel.fetchAnnouncement()
                    await mealsTask
                    await announcementTask
                }
            }
            .toolbar {
                Button {
                    Task {
                        async let mealsTask: () = viewModel.fetchMeals()
                        async let announcementTask: () = viewModel.fetchAnnouncement()
                        await mealsTask
                        await announcementTask
                    }
                } label: {
                    Text("오늘")
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
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if meal.mealCode != "3" {
                        Divider()
                            .padding(.horizontal, 5)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}
