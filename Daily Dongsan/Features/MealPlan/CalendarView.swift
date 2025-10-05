//
//  CalendarView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/15/24.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject private var viewModel = CalendarViewModel()
    
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
                    RegularCalendarView()
                } else {
                    CompactCalendarView()
                }
            }
            .environmentObject(viewModel)
            .navigationTitle("캘린더")
            .applyNavigationSubtitleIfAvailable(formattedDate)
            .navigationBarTitleDisplayMode(.inline)
            .task(id: viewModel.selectedDate) {
                await viewModel.fetchMeals()
            }
        }
    }
    
    private struct RegularCalendarView: View {
        @EnvironmentObject private var viewModel: CalendarViewModel
        
        private let selectedAllergies: Set<String> = {
            let ids = UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? []
            return Set(ids)
        }()
        
        var body: some View {
            HStack(alignment: .top) {
                VStack {
                    DatePicker("날짜 선택", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    Button("오늘") {
                        viewModel.selectedDate = Date()
                    }
                }
                
//                if viewModel.isLoading {
//                    RegularMealListView(meals: Meal.sampleMeals)
//                        .skeleton(isRedacted: true)
//                } else {
//                    RegularMealListView(meals: viewModel.meals)
//                }
                
                List(viewModel.meals, id: \.mealKind.rawValue) { meal in
                    Section {
                        if let menus = meal.menus, !menus.isEmpty {
                            VStack(alignment: .leading) {
                                ForEach(menus, id: \.self) { menu in
                                    if let list = menu.allergies, !list.isDisjoint(with: selectedAllergies) {
                                        Text(menu.name)
                                            .foregroundStyle(.red)
                                    } else {
                                        Text(menu.name)
                                    }
                                }
                            }
                            .contextMenu {
                                let menuNames = menus.compactMap({ $0.name })
                                
                                Button {
                                    UIPasteboard.general.strings = menuNames
                                } label: {
                                    Label("복사", systemImage: "document.on.document")
                                }
                                ShareLink(item: menuNames.joined(separator: "\n"))
                            }
                        } else {
                            Text("급식 정보가 없습니다.")
                        }
                    } header: {
                        HStack {
                            Text(meal.mealKind.displayName)
                            if let calorie = meal.calorieInfo {
                                Spacer()
                                Text(calorie)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .applyIf(viewModel.isLoading) { view in
                    view.hidden()
                        .overlay {
                            ProgressView()
                        }
                }
            }
        }
    }
    
    private struct CompactCalendarView: View {
        @EnvironmentObject private var viewModel: CalendarViewModel
        
        var body: some View {
            VStack(spacing: 0) {
                DatePicker("날짜 선택", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                
//                if viewModel.isLoading {
//                    CompactMealListView(meals: Meal.sampleMeals)
//                        .skeleton(isRedacted: true)
//                } else {
//                    CompactMealListView(meals: viewModel.meals)
//                }
                
                List(viewModel.meals, id: \.mealKind.rawValue) { meal in
                    Section {
                        if let menus = meal.menus, !menus.isEmpty {
                            Text(viewModel.attributedMenuList(for: menus))
                                .contextMenu {
                                    let menuNames = menus.compactMap({ $0.name }).joined(separator: ", ")
                                    
                                    Button {
                                        UIPasteboard.general.string = menuNames
                                    } label: {
                                        Label("복사", systemImage: "document.on.document")
                                    }
                                    ShareLink(item: menuNames)
                                }
                        } else {
                            Text("급식 정보가 없습니다.")
                        }
                    } header: {
                        HStack {
                            Text(meal.mealKind.displayName)
                            if let calorie = meal.calorieInfo {
                                Spacer()
                                Text(calorie)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .applyIf(viewModel.isLoading) { view in
                    view.hidden()
                        .overlay {
                            ProgressView()
                        }
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
    CalendarView()
}
