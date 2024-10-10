//
//  HomeView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var mealService: MealService
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    RegularHome(meals: mealService.meals, currentDate: currentDate, errorMessage: mealService.errorMessage)
                } else {
                    CompactHome(meals: mealService.meals, currentDate: currentDate, errorMessage: mealService.errorMessage)
                }
            }
            .padding(.horizontal)
            .navigationTitle("홈")
            .onAppear {
                mealService.fetchMeals(date: Date())
                
            }
        }
    }
    
    private struct RegularHome: View {
        let meals: [Meal]?
        let currentDate: () -> String
        let errorMessage: String?
        
        var body: some View {
            VStack {
                if let errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else if let meals {
                    Text(currentDate())
                        .font(.title3)
                        .bold()
                        .padding(.bottom)
                    
                    HStack(alignment: .top) {
                        ForEach(meals) { meal in
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text(meal.mealTime)
                                    Spacer()
                                    Text(meal.calorie)
                                }
                                .foregroundStyle(.gray)
                                
                                Text(meal.name)
                            }
                            
                            if meal.id != "3" {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private struct CompactHome: View {
        let meals: [Meal]?
        let currentDate: () -> String
        let errorMessage: String?
        
        var body: some View {
            VStack {
                if let errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else if let meals {
                    Text(currentDate())
                        .font(.title3)
                        .bold()
                    
                    List(meals) { meal in
                        Section {
                            Text(meal.name)
                        } header: {
                            HStack {
                                Text(meal.mealTime)
                                Spacer()
                                Text(meal.calorie)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
    }
    
    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MMMM d일 EEEE"
        return dateFormatter.string(from: Date())
    }
}

#Preview {
    HomeView()
        .environmentObject(MealService())
}
