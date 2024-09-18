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
            if horizontalSizeClass == .regular {
                RegularMealView(meals: mealService.meals, selectedDate: selectedDate, errorMessage: mealService.errorMessage)
            } else {
                CompactMealView(meals: mealService.meals, selectedDate: selectedDate, errorMessage: mealService.errorMessage)
            }
        }
        .listStyle(.plain)
        .padding(.horizontal)
        .onAppear {
            mealService.fetchMeals(date: selectedDate)
        }
        .onChange(of: selectedDate) {
            mealService.fetchMeals(date: selectedDate)
        }
    }
    
    private struct RegularMealView: View {
        let meals: [Meal]?
        @State var selectedDate: Date
        let errorMessage: String?
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text("안산동산고등학교")
                        .font(.footnote)
                        .bold()
                        .foregroundStyle(.gray)
                    Text("식단")
                        .font(.largeTitle)
                        .bold()
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
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
        @State var selectedDate: Date
        let errorMessage: String?
        
        var body: some View {
            DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
            
            if let errorMessage {
                Spacer()
                Text(errorMessage)
                    .multilineTextAlignment(.center)
                    .navigationTitle("식단")
                    .navigationBarTitleDisplayMode(.inline)
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
                .navigationTitle("\(formattedDate) 식단")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    MealsView()
        .environmentObject(MealService())
}
