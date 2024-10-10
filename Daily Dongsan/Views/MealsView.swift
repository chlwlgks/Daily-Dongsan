//
//  MealsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/15/24.
//

import SwiftUI

struct MealsView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var mealService: MealService
    
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    RegularMealView(meals: mealService.meals, selectedDate: $selectedDate, errorMessage: mealService.errorMessage)
                } else {
                    CompactMealView(meals: mealService.meals, selectedDate: $selectedDate, errorMessage: mealService.errorMessage)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .listStyle(.plain)
            .padding(.horizontal)
            .navigationTitle("식단")
            .onAppear {
                mealService.fetchMeals(date: selectedDate)
            }
            .onChange(of: selectedDate) {
                mealService.fetchMeals(date: selectedDate)
            }
        }
    }
    
    private struct RegularMealView: View {
        let meals: [Meal]?
        @Binding var selectedDate: Date
        let errorMessage: String?
        
        var body: some View {
            HStack(alignment: .top) {
                VStack(spacing: 16) {
                    DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    Button("오늘") {
                        selectedDate = Date()
                    }
                }
                
                VStack {
                    var formattedDate: String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ko_KR")
                        dateFormatter.dateFormat = "MMMM d일 EEEE"
                        return dateFormatter.string(from: selectedDate)
                    }
                    Text(formattedDate)
                        .font(.title3)
                        .bold()
                    
                    if let errorMessage {
                        HStack{
                            Spacer()
                            VStack {
                                Spacer()
                                Text(errorMessage)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            Spacer()
                        }
                    } else if let meals {
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
                    }
                }
            }
        }
    }
    
    private struct CompactMealView: View {
        let meals: [Meal]?
        @Binding var selectedDate: Date
        let errorMessage: String?
        
        var body: some View {
            VStack {
                DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                if let errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else if let meals {
                    var formattedDate: String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ko_KR")
                        dateFormatter.dateFormat = "MMMM d일 EEEE"
                        return dateFormatter.string(from: selectedDate)
                    }
                    
                    VStack {
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
                    }
                }
            }
        }
    }
}

#Preview {
    MealsView()
        .environmentObject(MealService())
}
