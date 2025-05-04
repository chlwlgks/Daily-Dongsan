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
    
    @State private var isConnected: Bool = true
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let calendar = Calendar.current
        let selectedYear = calendar.component(.year, from: viewModel.selectedDate)
        let currentYear = calendar.component(.year, from: Date())
        
        if selectedYear == currentYear {
            dateFormatter.dateFormat = "MMM d일 EEEE"
        } else {
            dateFormatter.dateFormat = "yyyy년 MMM d일 EEEE"
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
            .onAppear {
                Task {
                    await viewModel.fetchMeals()
                }
            }
            .onChange(of: viewModel.selectedDate) { _ in
                Task {
                    await viewModel.fetchMeals()
                }
            }
            .navigationTitle(horizontalSizeClass == .compact ? formattedDate + "식단" : "")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private struct RegularMealView: View {
        @ObservedObject var viewModel: MealPlanViewModel
        
        var body: some View {
            VStack {
                VStack(alignment: .leading) {
                    Text(viewModel.selectedDateAsString())
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(.gray)
                    Text("식단")
                        .font(.system(.largeTitle, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .top) {
                    VStack {
                        DatePicker("날짜", selection: $viewModel.selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                        
                        Button {
                            viewModel.selectedDate = Date()
                        } label: {
                            Text("오늘")
                        }
                    }
                    
                    RegularMealListView(meals: viewModel.meals)
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
                
                CompactMealListView(meals: viewModel.meals)
            }
            .toolbar {
                Button {
                    viewModel.selectedDate = Date()
                } label: {
                    Text("오늘")
                }
                
            }
        }
    }
}

#Preview {
    MealPlanView()
}
