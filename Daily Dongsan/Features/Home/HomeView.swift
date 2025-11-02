//
//  HomeView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 9/14/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var viewModel = HomeViewModel()
    
    private func refresh() async {
        async let a: Void = viewModel.fetchScheduleAndMeals()
        async let b: Void = viewModel.fetchAnnouncement()
        _ = await (a, b)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    RegularHomeView()
                    Spacer()
                } else {
                    CompactHomeView()
                }
            }
            .environment(viewModel)
            .task(id: scenePhase) {
                guard scenePhase == .active else { return }
                await refresh()
            }
            .navigationTitle("안산동산고등학교")
            .applyNavigationSubtitleIfAvailable(viewModel.currentDateAsString())
        }
    }
    
    private struct AnnouncementBanner: View {
        let text: String
        
        var body: some View {
            GroupBox {
                EmptyView()
            } label: {
                Label {
                    Text(text)
                } icon: {
                    Image(systemName: "megaphone.fill")
                        .foregroundStyle(.accent)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private struct CompactHomeView: View {
        @Environment(HomeViewModel.self) private var viewModel
        
        private let selectedAllergies: Set<String> = {
            let ids = UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? []
            return Set(ids)
        }()
        
        var body: some View {
            List {
                if #unavailable(iOS 26.0) {
                    Section {
                        Text(viewModel.currentDateAsString())
                            .foregroundStyle(.secondary)
                            .listSectionSeparator(.hidden)
                    }
                }
                
                if let announcement = viewModel.announcement, !announcement.isEmpty {
                    Section {
                        AnnouncementBanner(text: announcement)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .listSectionSeparator(.hidden)
                    }
                }
                
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
            }
            .listStyle(.plain)        }
    }
    
    private struct RegularHomeView: View {
        @Environment(HomeViewModel.self) private var viewModel
        
        private let selectedAllergies: Set<String> = {
            let ids = UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? []
            return Set(ids)
        }()
        
        var body: some View {
            VStack(alignment: .leading) {
                if #unavailable(iOS 26.0) {
                    Text(viewModel.currentDateAsString())
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
                
                if let announcement = viewModel.announcement, !announcement.isEmpty {
                    AnnouncementBanner(text: announcement)
                        .padding(.horizontal)
                }
                
                HStack {
                    if let schedule = viewModel.schedule {
                        List {
                            Section("학사 일정") {
                                Text(schedule)
                                    .listSectionSeparator(.hidden)
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
                        .scrollDisabled(true)
                        .listStyle(.plain)
                        .contentMargins(0)
                        
                        Divider()
                    }
                    ForEach(viewModel.meals, id: \.mealKind.rawValue) { meal in
                        List {
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
                            .listSectionSeparator(.hidden)
                        }
                        .scrollDisabled(true)
                        .listStyle(.plain)
                        .contentMargins(0)
                        
                        if meal.mealKind.rawValue != "3" {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
