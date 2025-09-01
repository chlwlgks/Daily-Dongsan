//
//  MealsView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/15/24.
//

import SwiftUI

struct MealPlanView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject private var viewModel = MealPlanViewModel()
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        let selectedYear = calendar.component(.year, from: viewModel.selectedDate)
        let currentYear = calendar.component(.year, from: Date())
        
        if selectedYear == currentYear {
            dateFormatter.dateFormat = "M월 d일 EEEE"
        } else {
            dateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        }
        
        return dateFormatter.string(from: viewModel.selectedDate)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    RegularMealView(viewModel: viewModel)
                } else {
                    CompactMealView(viewModel: viewModel)
                }
            }
            .navigationTitle(horizontalSizeClass == .compact ? formattedDate + " 식단" : "")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchMeals()
            }
            .onChange(of: viewModel.selectedDate) { _ in
                Task {
                    await viewModel.fetchMeals()
                }
            }
        }
    }
    
    private struct RegularMealView: View {
        @ObservedObject var viewModel: MealPlanViewModel
        
        var body: some View {
            VStack {
                VStack(alignment: .leading) {
                    Text(viewModel.selectedDateAsString())
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Text("식단")
                        .font(.system(.largeTitle, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .top) {
                    VStack {
                        DatePicker("날짜", selection: $viewModel.selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                        
                        Button("오늘") {
                            viewModel.selectedDate = Date()
                        }
                    }
                    
                    if viewModel.isLoading {
                        RegularMealListView(meals: Meal.sampleMeals)
                            .skeleton(isRedacted: true)
                    } else {
                        RegularMealListView(meals: viewModel.meals)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    private struct CompactMealView: View {
        @ObservedObject var viewModel: MealPlanViewModel
        
        var body: some View {
            VStack {
                DatePicker("날짜", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                
                if viewModel.isLoading {
                    CompactMealListView(meals: Meal.sampleMeals)
                        .skeleton(isRedacted: true)
                } else {
                    CompactMealListView(meals: viewModel.meals)
                }
            }
            .toolbar {
                Button("오늘") {
                    viewModel.selectedDate = Date()
                }
            }
        }
    }
}

#Preview {
    MealPlanView()
}
