//
//  CalendarView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/15/24.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var viewModel = CalendarViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    RegularCalendarView(viewModel: viewModel)
                } else {
                    CompactCalendarView(viewModel: viewModel)
                }
            }
            .navigationTitle("캘린더")
            .applyNavigationSubtitleIfAvailable(viewModel.selectedDateAsString)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("오늘") {
                    viewModel.selectedDate = Date()
                }
            }
            .task(id: viewModel.selectedDate) {
                await viewModel.fetchScheduleAndMeals()
            }
        }
    }
    
    private struct RegularCalendarView: View {
        @Bindable var viewModel: CalendarViewModel
        
        var body: some View {
            HStack(alignment: .top) {
                DatePicker("날짜 선택", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                List {
                    if let schedule = viewModel.schedule {
                        Section("학사 일정") {
                            Text(schedule)
                                .contextMenu {
                                    Button {
                                        UIPasteboard.general.string = schedule
                                    } label: {
                                        Label("복사", systemImage: "document.on.document")
                                    }
                                    ShareLink(item: schedule)
                                }
                        }
                    }
                    ForEach(viewModel.meals, id: \.mealKind.rawValue) { meal in
                        Section {
                            if let menus = meal.menus, !menus.isEmpty {
                                VStack(alignment: .leading) {
                                    ForEach(menus, id: \.self) { menu in
                                        if let list = menu.allergies, !list.isDisjoint(with: viewModel.selectedAllergies) {
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
        @Bindable var viewModel: CalendarViewModel
        
        var body: some View {
            VStack(spacing: 0) {
                DatePicker("날짜 선택", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                
                List {
                    if let schedule = viewModel.schedule {
                        Section("학사 일정") {
                            Text(schedule)
                                .contextMenu {
                                    Button {
                                        UIPasteboard.general.string = schedule
                                    } label: {
                                        Label("복사", systemImage: "document.on.document")
                                    }
                                    ShareLink(item: schedule)
                                }
                        }
                    }
                    ForEach(viewModel.meals, id: \.mealKind.rawValue) { meal in
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
}

#Preview {
    CalendarView()
}
