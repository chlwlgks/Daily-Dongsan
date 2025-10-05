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
    
    @StateObject private var viewModel = HomeViewModel()
    
    private func refresh() async {
        async let a: Void = viewModel.fetchMeals()
        async let b: Void = viewModel.fetchAnnouncement()
        _ = await (a, b)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
//                    if viewModel.isMealsLoading {
//                        RegularHomeView(meals: Meal.sampleMeals)
//                            .skeleton(isRedacted: true)
//                        
//                        ProgressView()
//                    } else {
//                        RegularHomeView(meals: viewModel.meals)
//                    }
                    
                    RegularHomeView()
                        .environmentObject(viewModel)
                    Spacer()
                } else {
//                    if viewModel.isMealsLoading {
//                        CompactHomeView(meals: Meal.sampleMeals)
//                            .environmentObject(viewModel)
//                            .skeleton(isRedacted: true)
//                        
//                        ProgressView()
//                    } else {
//                        CompactHomeView(meals: viewModel.meals)
//                            .environmentObject(viewModel)
//                    }
                    
                    CompactHomeView()
                        .environmentObject(viewModel)
                }
            }
            .task(id: scenePhase) {
                if scenePhase == .active {
                    await refresh()
                }
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private struct CompactHomeView: View {
        @EnvironmentObject private var viewModel: HomeViewModel
        
        private let selectedAllergies: Set<String> = {
            let ids = UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? []
            return Set(ids)
        }()
        
        var body: some View {
            List {
                if #unavailable(iOS 26.0) {
                    Text(viewModel.currentDateAsString())
                        .foregroundStyle(.secondary)
                        .listRowSeparator(.hidden)
                }
                
                if let announcement = viewModel.announcement, !announcement.isEmpty {
                    AnnouncementBanner(text: announcement)
                        .listRowSeparator(.hidden)
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
            .listStyle(.plain)
        }
    }
    
    private struct RegularHomeView: View {
        @EnvironmentObject private var viewModel: HomeViewModel
        
        private let selectedAllergies: Set<String> = {
            let ids = UserDefaults.standard.array(forKey: "SelectedAllergies") as? [String] ?? []
            return Set(ids)
        }()
        
        var body: some View {
            VStack {
                if #unavailable(iOS 26.0) {
                    Text(viewModel.currentDateAsString())
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if let announcement = viewModel.announcement, !announcement.isEmpty {
                    AnnouncementBanner(text: announcement)
                        .padding(.bottom)
                }
                
//                HStack {
                HStack(alignment: .top) {
                    ForEach(viewModel.meals, id: \.mealKind.rawValue) { meal in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(meal.mealKind.displayName)
                                if let calorie = meal.calorieInfo {
                                    Spacer()
                                    Text(calorie)
                                }
                            }
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.bottom)
                            
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
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
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
//                        List {
//                            Section {
//                                if let menus = meal.menus, !menus.isEmpty {
//                                    VStack(alignment: .leading) {
//                                        ForEach(menus, id: \.self) { menu in
//                                            if let list = menu.allergies, !list.isDisjoint(with: selectedAllergies) {
//                                                Text(menu.name)
//                                                    .foregroundStyle(.red)
//                                            } else {
//                                                Text(menu.name)
//                                            }
//                                        }
//                                    }
//                                    .contextMenu {
//                                        let menuNames = menus.compactMap({ $0.name })
//                                        
//                                        Button {
//                                            UIPasteboard.general.strings = menuNames
//                                        } label: {
//                                            Label("복사", systemImage: "document.on.document")
//                                        }
//                                        ShareLink(item: menuNames.joined(separator: "\n"))
//                                    }
//                                } else {
//                                    Text("급식 정보가 없습니다.")
//                                }
//                            } header: {
//                                HStack {
//                                    Text(meal.mealKind.displayName)
//                                    if let calorie = meal.calorieInfo {
//                                        Spacer()
//                                        Text(calorie)
//                                    }
//                                }
//                            }
//                            .listSectionSeparator(.hidden)
//                        }
//                        .scrollDisabled(true)
//                        .listStyle(.plain)
//                        .contentMargins(0)
//                        .listRowSpacing(0)
//                        .listSectionSpacing(.zero)
                        
                        if meal.mealKind.rawValue != "3" {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .scenePadding()
        }
    }
}

#Preview {
    HomeView()
}
